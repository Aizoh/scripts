## Navigate to (https://mailadmin.zoho.com)[zoho].
Through the admin panel the first step is to register your Domain 

- **Creating a TXT record**

Login to your DNS Server of your VPS(Contabo /Digital Ocean )

    -- Add a txt record with the value Generated from Zoho
    -- After creating Verify at Zoho the TXT record 

- **Creating Email Accounts on Zoho**

On Zoho Add the email accounts needed 

- **Creating Zoho MX Records**

    -- Now since you already have existing MX Records in your VPS replace them with Zoho MX Records eg `mail.contaco.space` with the following 
```php
| Priority | Mail Server  |
| -------- | ------------ |
| 10       | mx.zoho.com  |
| 20       | mx2.zoho.com |
| 50       | mx3.zoho.com |

➤ Add Record 1:
Name: @

Type: MX

Priority: 10

Data: mx.zoho.com

➤ Add Record 2:
Name: @

Type: MX

Priority: 20

Data: mx2.zoho.com

➤ Add Record 3:
Name: @

Type: MX

Priority: 50

Data: mx3.zoho.com

```
IN Addition to MX Records ZOHO witll Provide you with Credentials to register `SPF` and `DKIM` Records
see ` Zoho Admin Panel > Mail Admin Console > Email Authentication > DKIM ` also Find more on `DMARC`

### FANCY DETAILS 

## ✅ 1. TXT Record (Zoho Verification)
Purpose: Proves to Zoho that you own the domain (contaco.space).

Looks like: zoho-verification=zb1234567890abcdef

**Why it's needed: Zoho won't allow email setup until you've verified you're the real domain owner.**

## ✅ 2. MX Records (Mail Exchange Records)
Purpose: Tells the internet where to deliver email sent to @contaco.space.

Zoho values:

mx.zoho.com (Primary)

mx2.zoho.com (Backup)

mx3.zoho.com (Failsafe)

**Why it's needed: Without MX records pointing to Zoho, you won't receive emails.**

## ✅ 3. SPF Record (Sender Policy Framework)
Purpose: Says who is allowed to send emails on behalf of your domain.

Value: v=spf1 include:zoho.com ~all

**Why it's needed: Helps prevent email spoofing (spammers faking your domain). Improves inbox delivery.**

## ✅ 4. DKIM Record (DomainKeys Identified Mail)
Purpose: Adds a digital signature to your outgoing emails.

Zoho gives a long TXT record for zoho._domainkey.contaco.space

**Why it's needed: Verifies that email hasn’t been tampered with in transit. Increases trust and deliverability.**

## ✅ 5. DMARC Record (Domain-based Message Authentication, Reporting, and Conformance)
Purpose: Works with SPF and DKIM to define how mail servers should handle unauthenticated mail.

Example: v=DMARC1; p=none; rua=mailto:admin@contaco.space

**Why it's needed: Lets you monitor or reject spoofed emails and get reports about mail using your domain**
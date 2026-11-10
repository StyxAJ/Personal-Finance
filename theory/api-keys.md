#API keys

What it is: 
a long secret string that identifies which app is calling an API, like a password for a program instead of a person. Example: an app calls a weather API and sends its key with every request.

Why it exists: 
the API owner can know who’s calling, limit usage (rate limits), bill for it, and switch it off if it leaks.

Where it goes: 
usually in a request header (e.g. Authorization: Bearer <key> or x-api-key: <key>). Not in the URL, because URLs end up in logs.

The rule they want to hear: 
never put keys in your code or in git. Store them in environment variables or a .env file that’s in .gitignore, and rotate (replace) a key if it ever leaks.

API key vs login: 
a key identifies an app; OAuth/tokens identify a user and can expire.
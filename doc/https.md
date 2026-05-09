# Serve through HTTPS

### Install mkcert and nss
```bash
brew install mkcert nss
mkcert -install
mkcert localhost 127.0.0.1
```

That creates two files in your current directory. Then start Rails:


### Start Rails server

```bash
rails s -b 'ssl://localhost:3000?key=localhost-key.pem&cert=localhost.pem'
```

or in Procfile.dev

```
web: rails s -b 'ssl://localhost:3000?key=localhost-key.pem&cert=localhost.pem'
```

**watch out**

Don't add these two cert files to git!

```
localhost.pem
localhost-key.pem
```
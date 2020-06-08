# Cert automater

This project is designed to automate creating a local CA, server certificate, and user certificate for testing. This *NOT* for production.

### Usage:

1. Modify the `docker-compose.yaml` file with your own values:

| Environment Variable | Description | Example |
|----------------------|-------------|---------|
| CERT_PASSWORD | The password for the CA and all certificates. It is the same for all for simplicity's sake. | password |
| DOMAIN        | The domain to be applied to your server wildcard certificate. Generally needs to match your local domain. | example.com |
| USERNAME      | Username for the user certificate. Will be applied to the CN | john.doe |
| USER_EMAIL    | Email to be applied to the user certificate. | john.doe@example.com |  

2. Create a local directory to store the generated certificates outside of the ephemeral Docker container and update the `docker-compose.yaml` to map it into the container at `/certs`. For instance, run:

```
mkdir ~/test-certs
```

And update your `docker-compose.yaml` with:

```
volumes:
  - ~/test-certs:/certs
```

3. Run `docker-compose up` to generate certificates.

4. Check your host machine's directory you created in step 2. You should now have 3 directory, each container the respective generated certificates: `ca/` , `user/`, `server/`

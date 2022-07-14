## Deploying reference-design

Installation script assumes that you use **Ubuntu 20.04**. The deployment script can be executed from any machine that can run docker, shell and makefiles.

### Install required packages

```bash
sudo apt install docker.io make -y
```

If you don't have a **Debian** based distribution, you need to find a way to install such dependencies on your own.

### Add user to the docker group

```bash
sudo usermod -aG docker $USER
```

After execution of this command you need to reboot your provision server.

### Clone the repo

```bash
git clone https://github.com/obada-foundation/reference-design
cd reference-design
```

### Generate server certificates into **./ssh** folder

```bash
make certificates
```
After the success certificate generation, add **./ssh/ssh_key.pub** to the server that you want to install the **reference-design**. Below you can find instructions how to add a key for most popular cloud/hosting providers:

- [DigitalOcean](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/to-account/)
- [AWS EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
- You can also do this manually by looking into [this](https://linuxhandbook.com/add-ssh-public-key-to-server/) tutorial

### Generate **/deployment/compose/inventory** file

```bash
make deploy/inventory
```

### Deploy reference-design

```bash
make deploy/compose
```


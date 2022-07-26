## Deploying reference-design

Installation script assumes that you use **Ubuntu 20.04**. The deployment script can be executed from any machine that can run docker, shell and makefiles. Please check [this video](https://www.youtube.com/watch?v=QFU4kyESciM) if you need more information about the installation details.

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
make deploy/compose/install
```

## Customize UI for reference-design

Please check [this video](https://www.youtube.com/watch?v=5kmtYI3PyPI) if you need more information about how to change color scheme for reference-design installation. 

After reference design successfully deployed, you can customize basic UI parameters by running command:

```sh
make customize
```

For first parameter **Docker image name**, you need to specify a custom container name that going to be build by this command. You can use your organization name as a prefix (like **your-org/reference-design**). After this you can specify customize options or take defaults. Once command will complete you need to redeploy **reference-design**:

```sh
make deploy/compose/update
```

On question "Reference design docker image (use customize playbook to create custom image)" answer with your custom container name (**your-org/reference-design**). Once deploy will complate, you see your custom UI settings.

### Full list of custom UI options
| Option  | Default value |
| ------------- | ------------- |
| Logo path | /images/obada-logo.svg |
| Logo text | Blockchain Demo Site |
| Footer text | Copyright © 2018-2022 OBADA Foundation |
| Page background color | #eff1f4 |
| Main text color | #555555 | 
| Main text size | 15px | 
| Links text color | #3a99d8 | 
| Background color for top navigation (header) | #ffffff | 
| Text color for top navigation (header) | #555555 | 
| Background color for bottom navigation (footer) | #cacaca | 
| Text color for bottom navigation (footer) | #ffffff | 
| Primary color | #e74c3c |


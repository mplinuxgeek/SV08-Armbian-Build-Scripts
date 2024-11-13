
# SV08-Armbian-Build-Scripts

This repository contains scripts to build a custom Armbian image for the Sovol SV08, specifically configured to improve upon the limitations of the original BIGTREETECH CB1 image. The generated image aims to resolve issues such as outdated kernels, boot partition constraints, and network stability, while providing compatibility with USB Ethernet and Wi-Fi dongles.

## Goal
The primary goal of this project is to create an updated, optimized Armbian image tailored for the Sovol SV08 with the BIGTREETECH CB1 module. The custom image offers:

- Debian 12 with a more modern kernel
- Stability improvements, including resolved network flapping issues
- Full kernel module support for additional hardware
- Easy customization via the provided build script

## Getting Started

### Prerequisites
- Linux environment (Tested under Ubuntu 24.04, 24.10 is not supported by the Armbian build scripts)

### Cloning the Repository
Clone the repository to your local machine:

```bash
git clone https://github.com/mplinuxgeek/SV08-Armbian-Build-Scripts.git
cd SV08-Armbian-Build-Scripts
```

### Basic Configuration

The main script for building the image is `create_image.sh`. Before running it, edit the variables to customize the build.

1. Open the `create_image.sh` script in your preferred text editor:
   ```bash
   nano create_image.sh
   ```

2. Review and adjust the following variables as needed:

   - **REPO_URL**: The URL of the Armbian build repository, typically `https://github.com/armbian/build`.
   - **BOARD**: Specifies the target board for the image, e.g., `bigtreetech-cb1` for the BIGTREETECH CB1.
   - **BRANCH**: Sets the kernel branch; use `current` for a stable version or `edge` for a more experimental kernel.
   - **RELEASE**: Sets the Debian or Ubuntu release to use, such as `bookworm` for Debian 12.
   - **BUILD_DESKTOP**: Choose `yes` to build a desktop environment, or `no` to build a command-line only system.
   - **KERNEL_CONFIGURE**: Set to `yes` if you want to manually configure kernel options during build, or `no` to use the default configuration.
   - **BUILD_MINIMAL**: Set to `yes` to build a minimal image with essential packages only.
   - **NETWORKING_STACK**: Defines the networking stack; options include `network-manager` or `ifupdown`.
   - **CONSOLE_AUTOLOGIN**: Enable autologin on console by setting to `yes`, or `no` to require a login.
   - **INCLUDE_HOME_DIR**: Set to `yes` to include the `/home` directory content in the image.
   - **WIREGUARD**: Include WireGuard VPN support by setting to `yes`, or `no` to exclude it.
   - **CLEAN_LEVEL**: Specifies the level of cleaning during the build process, e.g., `caches,alldebs,sources,oldcache` to clear cache and intermediate files.

3. Save and close the file.

### Running the Script

With the configuration set, you can now run the `create_image.sh` script:

```bash
./create_image.sh
```

This will generate a bootable Armbian image with the specified settings. The process may take some time depending on the system’s resources and network speed.

## Contributing

Contributions to improve the build process, add functionality, or resolve issues are welcome. Feel free to fork the repository, create a feature branch, and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy building!

<h1 align="center">🐧 Informix SDK and PDO PHP Informix Installation Scripts</h1>
<h3 align="center">These scripts aim to simplify the installation of the Informix SDK and compilation of the PDO PHP Informix driver on Debian systems.</h3>

## Overview

Starting April 2025, I will no longer provide maintenance or updates for this repository, as I am no longer working with Informix and Laravel.
However, pull requests are still welcome and will be reviewed.

Thank you for your understanding.

The Informix SDK Installation Script (`install_informix_sdk.sh`) automates the setup of the Informix Software Development Kit (SDK) on Debian. It performs the following steps:

1. **Download the Informix SDK from IBM's website**.
2. Copy and extract the temporary installation folder.
3. Install missing libraries required by the Informix SDK.
4. Install the Informix SDK in the specified directory.
5. Create a symbolic link for easy access to the SDK.
6. Remove the temporary installation folder.
7. Configure the Informix SDK by adding necessary paths to the dynamic library configuration file.

The Informix PDO Compilation Script (`compile_informix_pdo.sh`) facilitates the compilation of the PDO PHP Informix driver on a Debian system. Its main features include:

1. Install PHP with necessary extensions.
2. Download the PDO Informix driver from PECL.
3. Extract the PDO Informix driver.
4. Compile the PDO Informix driver for the specified PHP version.
5. Install the compiled PDO Informix driver.
6. Clean up temporary files.
7. Configure the PDO Informix driver in the PHP configuration.
8. Enable the PHP-FPM service at startup.
9. Restart the PHP-FPM service to apply the changes.

## Compatibility

These scripts have been successfully tested on Debian 12.

## Contribution

We welcome community contributions. Fork, make changes, submit a pull request.

## License

This project is licensed under the [MIT](LICENSE) License.
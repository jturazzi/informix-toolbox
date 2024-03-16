<h1 align="center">🐧 Scripts d'installation pour Informix sur Debian</h1>
<h3 align="center">Ces scripts visent à simplifier l'installation du SDK Informix et la compilation du pilote PDO PHP Informix sur les systèmes Debian.</h3>

## Vue d'ensemble

Le script d'Installation du SDK Informix (`install_informix_sdk.sh`) automatise la configuration du Kit de Développement Logiciel (SDK) Informix sur Debian. Il effectue les étapes suivantes :

1. **Téléchargement du SDK Informix depuis le site d'IBM**.
2. Copie et extraction du dossier d'installation temporaire.
3. Installation des librairies manquantes requises par le SDK Informix.
4. Installation du SDK Informix dans le répertoire spécifié.
5. Création d'un lien symbolique pour faciliter l'accès au SDK.
6. Suppression du dossier d'installation temporaire.
7. Configuration du SDK Informix en ajoutant les chemins nécessaires au fichier de configuration des bibliothèques dynamiques.

Le script de compilation du PDO PHP Informix (`compile_informix_pdo.sh`) facilite la compilation du pilote PDO PHP Informix sur un système Debian. Ses fonctionnalités principales comprennent :

1. Installation de PHP avec les extensions requises.
2. Téléchargement du pilote PDO Informix depuis PECL.
3. Extraction du pilote PDO Informix.
4. Compilation du pilote PDO Informix pour la version PHP spécifiée.
5. Installation du pilote PDO Informix compilé.
6. Nettoyage des fichiers temporaires.
7. Configuration du pilote PDO Informix dans la configuration PHP.
8. Activation du service PHP-FPM au démarrage.
9. Redémarrage du service PHP-FPM pour appliquer les modifications.

## Compatibilité

Ces scripts ont été testés avec succès sur Debian 12.

## Licence

Ce projet est sous licence [MIT](LICENSE).
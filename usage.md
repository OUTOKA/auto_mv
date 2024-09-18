#### Antoine Didierjean
#### Hugo Bienvenu

# Script de gestion des machines virtuelles VirtualBox

## Introduction

Ce script bash permet de créer, démarrer, arrêter, supprimer et lister des machines virtuelles sous VirtualBox en utilisant l'outil `VBoxManage`. De plus, il offre la possibilité de créer plusieurs machines virtuelles d'un seul coup avec des noms uniques.

## Prérequis

Avant d'utiliser ce script, assurez-vous d'avoir installé VirtualBox sur votre système. Le script utilise l'outil `VBoxManage` qui est fourni avec VirtualBox.

## Installation

### 1. Téléchargez ou clonez ce script sur votre machine.
### 2. Assurez-vous que VirtualBox est installé en vérifiant la présence de `VBoxManage` :

   VBoxManage --version

Donnez les permissions d'exécution au script :

chmod +x genMV.sh

Utilisation

## 1. Créer plusieurs machines virtuelles
Pour créer plusieurs machines virtuelles avec un nom unique (basé sur le même préfixe suivi d'un numéro), utilisez la commande suivante :

./genMV.sh create <nombre_de_VM>
 
### Exemple : Pour créer 5 machines virtuelles :

./genMV.sh create 5

Cela créera des machines virtuelles avec les noms DebianVM1, DebianVM2, DebianVM3, DebianVM4, DebianVM5.

Par défaut, chaque VM aura les configurations suivantes :

Nom : DebianVM suivi d'un numéro
RAM : 4096 MB (modifiable dans le script)
Disque dur : 64 GB (modifiable dans le script)
Type OS : Debian 64 bits (modifiable dans le script)

## 2. Démarrer une machine virtuelle
Pour démarrer une machine virtuelle, utilisez la commande suivante :

./genMV.sh start <nom_de_VM>

### Exemple : Pour démarrer la VM DebianVM1 :

./genMV.sh start DebianVM1

### 3. Arrêter une machine virtuelle
Pour arrêter une machine virtuelle, utilisez la commande suivante :

./genMV.sh stop <nom_de_VM>

### Exemple : Pour arrêter la VM DebianVM2 :

./genMV.sh stop DebianVM2

## 4. Supprimer une machine virtuelle
   
Pour supprimer une machine virtuelle, utilisez la commande suivante :

./genMV.sh delete <nom_de_VM>

### Exemple : Pour supprimer la VM DebianVM3 :

./genMV.sh delete DebianVM3

Cette commande supprimera également les fichiers associés à la machine virtuelle.

## 5. Lister toutes les machines virtuelles
Pour lister toutes les machines virtuelles actuellement enregistrées dans VirtualBox, utilisez la commande suivante :

./genMV.sh list

Cela affichera la liste des machines virtuelles enregistrées sur votre système VirtualBox.

Structure des commandes
Le script supporte les commandes suivantes :

./genMV.sh {create <nombre>|start <nom>|stop <nom>|delete <nom>|list}

create <nombre> : Crée plusieurs machines virtuelles avec un nom unique. Le nom de base par défaut est DebianVM suivi d'un numéro incrémenté.

start <nom> : Démarre une machine virtuelle spécifiée.

stop <nom> : Arrête une machine virtuelle spécifiée.

delete <nom> : Supprime une machine virtuelle spécifiée et ses fichiers.

list : Affiche la liste des machines virtuelles.
Modifications

Vous pouvez ajuster les paramètres suivants dans le script selon vos besoins :

Nom de base de la machine virtuelle : Modifiez la variable VM_BASE_NAME pour changer le nom de base des VMs.

Taille de la RAM : Modifiez la variable VM_RAM pour définir la quantité de RAM par défaut pour chaque VM.

Taille du disque dur : Modifiez la variable VM_DISK pour définir la taille du disque dur virtuel.

Type de système d'exploitation : Modifiez la variable VM_OS_TYPE pour changer le type du système d'exploitation utilisé (par exemple, Debian_64, Ubuntu_64, etc.).

## Exemples d'utilisation

### Créer 3 machines virtuelles

./genMV.sh create 3

Cela créera 3 machines virtuelles nommées DebianVM1, DebianVM2, et DebianVM3.

### Démarrer une machine virtuelle

./genMV.sh start DebianVM1

Cela démarrera la machine virtuelle DebianVM1 en mode headless.

### Arrêter une machine virtuelle

./genMV.sh stop DebianVM2

Cela arrêtera la machine virtuelle DebianVM2.

### Supprimer une machine virtuelle

./genMV.sh delete DebianVM3

Cela supprimera la machine virtuelle DebianVM3 et ses fichiers associés.

### Lister les machines virtuelles

./genMV.sh list

Cela affichera la liste des machines virtuelles enregistrées dans VirtualBox.

## Dépannage

VBoxManage non trouvé : Si vous recevez un message disant que VBoxManage n'est pas installé, assurez-vous que VirtualBox est correctement installé et que l'outil VBoxManage est dans votre PATH.

Erreur lors de la création ou de la suppression d'une VM : Assurez-vous que vous avez les permissions nécessaires pour écrire dans le répertoire où les machines virtuelles sont stockées, et qu'aucune autre machine virtuelle ne porte le même nom.

## Amélioration par rapport à la première année

- Possibilité de création de plusieurs machines en même temps qui ont toutes un nom différent.
- Ajout de la fonction usage qui permet d'obtenir l'aide du script avec toutes les commandes possibles.
- Ajout de la fonction qui vérifie si VBox Manage est bien installé.


#!/bin/bash

# Variables globales par défaut
VM_BASE_NAME="DebianVM"
VM_RAM="4096"  # RAM en MB (ne pas inclure "MB")
VM_DISK="64"   # Taille du disque en GB (ne pas inclure "GB")
VM_OS_TYPE="Debian_64"

# Vérifie si VBoxManage est installé
check_vboxmanage() {
    if ! command -v VBoxManage &> /dev/null; then
        echo "VBoxManage n'est pas installé. Veuillez installer VirtualBox pour continuer."
        exit 1
    fi
}

# Fonction pour créer une machine virtuelle avec un nom unique
create_vm() {
    VM_NAME="$1"
    VM_HD_PATH="$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"

    echo "Création de la machine virtuelle $VM_NAME..."

    # Vérifier si une VM avec le même nom existe déjà
    if VBoxManage list vms | grep -q "\"$VM_NAME\""; then
        echo "Une machine virtuelle avec le nom $VM_NAME existe déjà."
        read -p "Voulez-vous la supprimer ? (y/n) " confirm
        if [[ $confirm == "y" ]]; then
            delete_vm "$VM_NAME"
        else
            echo "Opération annulée."
            return
        fi
    fi

    # Créer la machine virtuelle
    VBoxManage createvm --name "$VM_NAME" --ostype "$VM_OS_TYPE" --register
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création de la machine virtuelle."
        exit 1
    fi

    # Configurer la mémoire RAM
    VBoxManage modifyvm "$VM_NAME" --memory "$VM_RAM" --boot1 dvd --nic1 nat
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la configuration de la RAM."
        exit 1
    fi

    # Créer et attacher un disque virtuel
    VBoxManage createhd --filename "$VM_HD_PATH" --size $(($VM_DISK * 1024)) --format VDI
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du disque virtuel."
        exit 1
    fi
    VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_HD_PATH"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'attachement du disque dur."
        exit 1
    fi

    # Configurer le réseau en mode NAT
    VBoxManage modifyvm "$VM_NAME" --nic1 nat
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la configuration réseau."
        exit 1
    fi

    echo "Machine virtuelle $VM_NAME créée avec succès."
}

# Fonction pour démarrer une machine virtuelle
start_vm() {
    VM_NAME="$1"
    echo "Démarrage de la machine virtuelle $VM_NAME..."
    VBoxManage startvm "$VM_NAME" --type headless
    if [ $? -eq 0 ]; then
        echo "Machine virtuelle $VM_NAME démarrée avec succès."
    else
        echo "Erreur lors du démarrage de la machine virtuelle."
        exit 1
    fi
}

# Fonction pour arrêter une machine virtuelle
stop_vm() {
    VM_NAME="$1"
    echo "Arrêt de la machine virtuelle $VM_NAME..."
    VBoxManage controlvm "$VM_NAME" poweroff
    if [ $? -eq 0 ]; then
        echo "Machine virtuelle $VM_NAME arrêtée."
    else
        echo "Erreur lors de l'arrêt de la machine virtuelle."
        exit 1
    fi
}

# Fonction pour supprimer une machine virtuelle
delete_vm() {
    VM_NAME="$1"
    echo "Suppression de la machine virtuelle $VM_NAME..."
    VBoxManage unregistervm "$VM_NAME" --delete
    if [ $? -eq 0 ]; then
        echo "Machine virtuelle $VM_NAME supprimée avec succès."
    else
        echo "Erreur lors de la suppression de la machine virtuelle."
        exit 1
    fi
}

# Fonction pour lister toutes les machines virtuelles
list_vms() {
    echo "Liste des machines virtuelles :"
    VBoxManage list vms
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la récupération de la liste des machines virtuelles."
        exit 1
    fi
}

# Fonction d'usage pour afficher l'aide
usage() {
    echo "Usage: $0 {create <nombre>|start|stop|delete|list}"
    echo "  create <nombre>  - Créer plusieurs nouvelles machines virtuelles (le nombre spécifié)"
    echo "  start <nom>      - Démarrer une machine virtuelle"
    echo "  stop <nom>       - Arrêter une machine virtuelle"
    echo "  delete <nom>     - Supprimer une machine virtuelle"
    echo "  list             - Lister toutes les machines virtuelles"
    exit 1
}

# Vérifier si VBoxManage est installé
check_vboxmanage

# Vérification des arguments passés au script
if [ $# -eq 0 ]; then
    usage
fi

# Exécution des fonctions en fonction de l'argument
case "$1" in
    create)
        if [ -z "$2" ]; then
            echo "Veuillez spécifier le nombre de machines virtuelles à créer."
            exit 1
        fi

        # Boucle pour créer plusieurs machines virtuelles
        for i in $(seq 1 "$2"); do
            VM_NAME="${VM_BASE_NAME}${i}"
            create_vm "$VM_NAME"
        done
        ;;
    start)
        if [ -z "$2" ]; then
            echo "Veuillez spécifier le nom de la machine virtuelle à démarrer."
            exit 1
        fi
        start_vm "$2"
        ;;
    stop)
        if [ -z "$2" ]; then
            echo "Veuillez spécifier le nom de la machine virtuelle à arrêter."
            exit 1
        fi
        stop_vm "$2"
        ;;
    delete)
        if [ -z "$2" ]; then
            echo "Veuillez spécifier le nom de la machine virtuelle à supprimer."
            exit 1
        fi
        delete_vm "$2"
        ;;
    list)
        list_vms
        ;;
    *)
        usage
        ;;
esac

exit 0


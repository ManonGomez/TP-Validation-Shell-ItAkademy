#!/bin/sh

echo -e "\e[36m Bienvenue sur mon script d'installation de Vagrant et Virtualbox !\e[0m "
echo -e "\e[36m --Pas besoin d'être un expert, vous avez juste à répondre à quelques questions--\e[0m "
echo -e "\e[33m Attention ne mettez pas de majuscules ni d'espace dans les noms ni les réponses !\e[0m "
#menu global
menu(){
    echo "vous êtes ici"
    pwd
    echo "----"
    echo "Que faire ?"
    echo "1) Lancer l'installation"
    echo "2) Tout quitter"
    read -p "Votre choix : " choice
}
#menu des paramètres de Vagrant
param(){
    echo "Maintenant on passe aux paramètres ! Que faire ?"
    echo "1) Nommer le fichier"
    echo "2) Selectionner une box (il y a 3 choix)"
    echo "3) Modifier l'adresse IP"
    echo "4) Gérer Vargant"
    echo "5) Installer les packets"
    echo "----"
}
open(){
    echo "Ouvrir Vargant ?"
    echo "1) oui"
    echo "2) non"
    echo "----"
}
menu

while [[ $choice != 2 ]]
do
#Vérifier si Vagrant est déjà installé
dpkg -s Vagrant | grep Status && echo " Zut Vagrant est déjà installé" || sudo apt install Vagrant
    clear
    echo "Nous avons vérifier Vagrant n'éxiste pas dans l'ordinateur, c'est parti pour l'installer" sleep 2
    #Installation de Vagrant 
    vagrant init && echo "Le fichier à été crée maintenant dites-moi vous préférences pour le paramétrage" || echo "Il y a eu une erreur, recommencez et vérifiez bien"
    sed -i 's/# config.vm.synced_folder "..\/data", "\/vagrant_data"/config.vm.synced_folder ".\/data", "\/var\/www\/html"/g' Vagrantfile
    mkdir data
    param
        while read -p "Votre choix : " paramChoice
        do
        case $paramChoice in
            1)  read -p "Vous voulez donner quel nom au fichier ? " folderName
                sed -i 's/config.vm.synced_folder ".\/data", "\/var\/www\/html"/config.vm.synced_folder ".\/'$folderName'", "\/var\/www\/html"/g' Vagrantfile
                mkdir $folderName
                rm -rf data
                echo "C'est fait !" sleep 2
                echo "----"
                open
            ;;
            2)  echo "Vous avez le choix en ces trois box: "
                echo "1) centos/7"
                echo "2) ubuntu/xenial64"
                echo "3) ubuntu/trusty64"
                read -p "Quelle est votre préference ?" boxChoice
                    case $boxChoice in
                        1) sed -i 's/config.vm.box = "base"/config.vm.box = "centos\/7"/g' Vagrantfile && echo "C'est bon le changement est fait !" || echo "Oops ERREUR !"   
                        ;;
                        2) sed -i 's/config.vm.box = "base"/config.vm.box = "ubuntu\/xenial64"/g' Vagrantfile && echo "C'est bon le changement est fait !" || echo "Oops ERREUR !"     
                        ;;
                        3) sed -i 's/config.vm.box = "base"/config.vm.box = "ubuntu\/trusty64"/g' Vagrantfile && echo "C'est bon le changement est fait !" || echo "Oops ERREUR !" 
                        ;;
                        # * = tout le reste
                        *) echo -e "\e[33m Vous avez fait une erreur ! \e[0m " sleep 2
                        menu
                        ;;
                    esac
            ;;
            3)  read -p "Quel est l'adresse IP que vous voulez utiliser ? " ipAdress
                sed -i 's/# config.vm.network "private_network", ip: "192.168.33.10"/config.vm.network "private_network", ip: "'$ipAddress'"/g' Vagrantfile
                echo "C'est fait !" sleep 2
                open
            ;;
            4)  echo "1) Voir tous les Vagrant"
                echo "2) Eteindre cette machine"
                read -p "Quel est votre choix ? " vagChoice
                case $vagChoice in
                    1) ls Vagrant
                    ;;
                    2) Vagrant halt
                    ;;
                esac
                echo "----"
                open
            
            ;;
            5)  echo "Maintenant il reste plus qu'à installer les paquets PHP, Apache, MySql, un peu ede patience et c'est fini !"
                echo -e "\e[33m Attention MySql va vous demander un mot de passe, ce dernier est 0000\e[0m " sleep 5
                command="sudo apt install apache2 php7 mysqlserver"
                vagrant ssh -c "$command -y"
                echo "C'est fait !" sleep 2
                echo "----"
                open
            ;;


        esac
        done
open                  
while read -p "Quel est votre choix ? " openChoice
do
    case $openChoice in
    1)  # Lancement de la vagrant
        vagrant up
    ;;
    2) menu
    ;;
    esac
done

done



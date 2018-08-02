#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#backup
#crontab -e
# 0 0 1 * * cp -Rf /home/ikovalev/musicLibrary /home/ikovalev/backup

write_text() {

  echo "Now you can enter song's text. If you want to stop it write: end_of_song"
  read data
  touch "$DIR/$1.text"
  file_name="$DIR/$1.text"
  while [ "$data" != "end_of_song" ]
  do
    echo "$data" >> $file_name
    read data
  done
}

find_file() {

  if [ "`ls $DIR | grep $1`" != "" ]
  then
    echo "File exist"
  else
    echo "File doesn't exist"
  fi


}



echo " "
echo "************************************************************"
echo "This program was created for working with your music library"
echo "************************************************************"
echo ""
echo "1 - Add song to the library"
echo "2 - Delete song from the library"
echo "3 - Add text"
echo "4 - Find song"
echo "5 - Find text file"
echo "6 - Find text by words"
echo "7 - Exit"  
echo ""

while true
do
  echo "Command: ";
  read command

  case "$command" in

       "1") #add song

         echo "Please, enter a path to folder with song"
         read path

         echo "File's name"
         read name
         new_name=$name

         while [ "`ls $DIR | grep $new_name`" != "" ]
         do
         echo "File is already exist. Please create new name for this file"
         read new_name
         done

         if [[ $new_name = *.mp3 || $new_name = *.flac || $new_name = *.wav ]]
         then
           size=$(stat -c%s "$path/$name")
           max_size=10000000
           if [ $size -lt $max_size ]
           then
             cp "$path/$name" "$DIR/$new_name"
             echo "Ready"
             echo "User $USER added song called $new_name. `date`" >> history.txt
           else
             echo "File size must be less than 10 Mb"
           fi
         else
           echo "Inappropriate file format. You can add only .mp3 .flac .wav"
         fi 

       ;;

       "2") #delete

         echo "Enter file's name"
         read name
         rm $name
         echo "User $USER deleted song called $name. `date`" >> history.txt

       ;;

       "3") #add text

         echo "Enter file's name"
         read name
         if [ "`ls $DIR | grep $name`" != "" ]
         then
           new_name="$name.text"
           if [ "`ls $DIR | grep $new_name`" != "" ]
           then
             echo "Text of this song has already exist. Do you want to rewrite it? (y/n)"
             read answer
             if [ "$answer" = "y" ]
             then
               write_text $name
             fi
           else
             write_text $name
           fi
         else
           echo "This song doesn't exist"
         fi

       ;;

       "4") #find song

         echo "Enter song's name wich you want to find"
         read name
         find_file "$name"

       ;;

       "5") #find text file

         echo "Enter song's name to find text of this song"
         read name
         find_file "$name.text"
       ;;

       "6") #find text by words

         echo "Enter words from a text wich you want to find"
         read text
         files="`find $DIR | grep .text`"
         result="`grep  $text $files`"
         if [ result != "" ]
         then
           grep --color $text $files
         else
           echo "Not found"
         fi

       ;;


       "7") #exit

         echo "Godbye! See you soon"
         exit 1

       ;;

       "*")

         echo "False request"
       ;;

  esac



done

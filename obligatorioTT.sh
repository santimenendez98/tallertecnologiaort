#!/bin/bash

usuarios="usuarios.txt";
diccionario="diccionario.txt";
registroDiccionario="registroDiccionario.txt";
datoIncorrecto=true;

#En esta parte se encuentra la funcion de menu principal con toda su logica dentro

menu_principal(){
	echo "----------------"
	echo "Menu Principal"
	echo "----------------"
	echo "1) Ver lista de usuarios"
	echo "2) Dar de alta un usuario"
	echo "3) Cerrar Sesion"
	echo "4) Ingresar letra inicial"
	echo "5) Ingresar letra final"
	echo "6) Ingresar letra contenida"
	echo "7) Buscar la palabra"
 	echo "8) Ingresar letra vocal"
	echo "9) Mostrar palabra con vocal del diccionario"
    	echo "11) Palabra capicua"
	read dato;
	datoNumero=$((dato));

	while [[ $datoNumero -lt 1 || $datoNumero -gt 11 ]]; do
		echo "Dato ingresado incorrecto"
		read dato;
		datoNumero=$((dato));
	done;

	if [ $datoNumero = 1 ]; then
		cat $usuarios;
		echo "Para volver digite (S)"
		read salir;
		while [[ $salir != "s" && $salir != "S" ]]; do
                	echo "Dato incorrecto"
                	read $salir
        	done
		menu_principal;
	elif [ $datoNumero = 2 ]; then
		echo "Ingrese nombre de nuevo usuario"
		read nuevoNombreUsuario;
		echo "Ingrese password"
		read nuevaPassword;
		nuevoUsuario="usuario: $nuevoNombreUsuario, password: $nuevaPassword"
		
		if grep -q "usuario: $nuevoNombreUsuario" $usuarios; then
		       	echo "El usuario ya existe"
		       	menu_principal
	       	else
			echo "$nuevoUsuario" >> $usuarios
	 		echo "Usuario creado correctamente"
			menu_principal
		fi		
	elif [ $datoNumero = 3 ]; then
		echo "Estas seguro de cerrar sesion? Ingrese (S) de lo contrario se volvera al menu principal"
		read alerta;
		if [ $alerta = "S" ] || [ $alerta = "s" ]; then
			echo "Sesion cerrada"
		else
			menu_principal
		fi
	elif [ $datoNumero = 4 ]; then
		echo "Ingrese la letra inicial"
		read letraInicial
		while [ ${#letraInicial} -ne 1 ]; do
			echo "La cadena debe contener una sola letra"
			read letraInicial
		done
		echo "Letra inicial guardada"
		menu_principal
	elif [ $datoNumero = 5 ]; then
		echo "Ingrese la letra final"
                read letraFinal
                while [ ${#letraFinal} -ne 1 ]; do
                        echo "La cadena debe contener una sola letra"
                        read letraFinal
                done
                echo "Letra final guardada"
                menu_principal
	elif [ $datoNumero = 6 ]; then
		echo "Ingrese la letra contenida"
                read letraContenida
                while [ ${#letraContenida} -ne 1 ]; do
                        echo "La cadena debe contener una sola letra"
                        read letraContenida
                done
                echo "Letra contenida guardada"
                menu_principal
	elif [ $datoNumero = 7 ]; then

		#Opcion para devolver palabras del diccionario que cumplen con la opcion 4,5 y 6. Aparte crea un registro dentro del archivo registroDiccionario.txt

		verificarPrimerLetra="${letraInicial:0:1}"
		verificarUltimaletra="${letraFinal: -1}"
		verificarLetraContenida="$letraContenida"

		if [ ${#letraInicial} -ne 1 ] || [ ${#letraFinal} -ne 1 ] || [ ${#letraContenida} -ne 1 ]; then
			echo "Se debe ingresar todos los datos antes de buscar la palabra"
			menu_principal
		else
			fecha=$(date +"%Y-%m-%d")
            palabrasEncontradas=$(grep -c "^$verificarPrimerLetra.*$verificarUltimaletra.*$verificarLetraContenida" $diccionario)
            palabrasDiccionario=$(grep -c "" $diccionario)
			porcentaje=$(bc <<< "scale=2; ($palabrasEncontradas * 100 / $palabrasDiccionario)")
            registro="Fecha de busqueda: $fecha, Cantidad de palabras encontradas: $palabrasEncontradas, Total de palabras del diccionario: $palabrasDiccionario, Porcentaje de palabras encontradas: $porcentaje%, Usuario: "$nombre""
            grep "^$verificarPrimerLetra.*$verificarLetraContenida.*$verificarUltimaletra$" $diccionario;
            echo "$registro" >> $registroDiccionario
			echo "Las palabras que inician con ($letraInicial), terminan con ($letraFinal) y contienen la letra ($letraContenida) son estas, para vovolver al menu principal digite (S)";
			read dato
			while [[ $dato != "s" && $dato != "S" ]]; do
                 		echo "Dato incorrecto"
                 		read $dato
        		done
			menu_principal
		fi
	elif  [ $datoNumero = 8 ]; then
        	echo "Ingrese la letra vocal"
        	read letraVocal
        	while [ ${#letraVocal} -ne 1 ] || [ $letraVocal != "a" ] && [ $letraVocal != "e" ] && [ $letraVocal != "i" ] && [ $letraVocal != "o" ] && [ $letraVocal != "u" ] && [ $letraVocal != "A" ] && [ $letraVocal != "E" ] && [ $letraVocal != "I" ] && [ $letraVocal != "O" ] && [ $letraVocal != "U" ]; do 
                	echo "La cadena debe contener una sola letra y debe ser vocal"
                	read letraVocal
        	done
        	echo "Letra vocal guardada"
        	menu_principal
	elif [ $datoNumero = 9 ]; then
		if [ -z "$letraVocal" ]; then
			echo "Debe ingresar una letra vocal en la opcion 8"
			menu_principal
		else
        		echo "Estas son las palabras del diccionario que contienen unicamente la vocal $letraVocal"
        		grep -i "^[^aeiou]*[$letraVocal][^aeiou]*$" $diccionario
        		menu_principal
		fi
	elif [ $datoNumero = 11 ]; then
        	echo "Ingrese palabra a verificar"
        	read palabra
       		alreves=""
        	ok=1
        	len=${#palabra}
        	for (( i=$len-1; i>=0; i-- )) do
            		alreves="$alreves${palabra:$i:1}"
        	done
        	if [ "$palabra" != "$alreves" ]; then
            		ok=0
        	fi
        	if [ $ok -eq 1 ]; then
            		echo "La palabra ingresada es capicua"
        	else
            		echo "La palabra igresada NO es capicua"
        	fi
        	menu_principal
    	fi
}

#Esta parte verifica si el usuario esta registrado y permite el inicio de sesion

while $datoIncorrecto; do
	echo "Ingrese nombre de usuario";

	read nombre;

	echo "Ingrese password";

	read -rs password;

	if grep -q "usuario: *$nombre, *password: *$password" $usuarios && [ -n "$password" ]; then
		datoIncorrecto=false;
		echo "Inicio de sesion correcto"
		echo "Bienvenido/a $nombre"
		menu_principal "$nombre";

	else
		datoIncorrecto=true;
		echo "Usuario y/o password no existen"
	fi
done;

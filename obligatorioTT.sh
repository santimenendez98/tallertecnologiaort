#!/bin/bash

usuarios="usuarios.txt";
diccionario="diccionario.txt";

datoIncorrecto=true;

#En esta parte se encuentra la funcion de validar error, es una funcion que valida el digito para salir de cada submenu

validar_error(){
	while [[ $1 != "s" && $1 != "S" ]]; do
        	 echo "Dato incorrecto"
                 read $1
        done

}

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
	read dato;
	datoNumero=$((dato))

	while [[ $datoNumero -lt 1 || $datoNumero -gt 8 ]]; do
		echo "Dato ingresado incorrecto"
		read dato;
		datoNumero=$((dato));
	done;

	if [ $datoNumero = 1 ]; then
		cat $usuarios;
		echo "Para volver digite (S)"
		read salir;
		validar_error $salir
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
		verificarPrimerLetra="${letraInicial:0:1}"
		verificarUltimaletra="${letraFinal: -1}"
		verificarLetraContenida="$letraContenida"

		if [ ${#letraInicial} -ne 1 ] || [ ${#letraFinal} -ne 1 ] || [ ${#letraContenida} -ne 1 ]; then
			echo "Se debe ingresar todos los datos antes de buscar la palabra"
			menu_principal
		else
			grep "^$verificarPrimerLetra.*$verificarUltimaletra.*$verificarLetraContenida" $diccionario
			echo "Las palabras que inician con ($letraInicial), terminan con ($letraFinal) y contienen la letra ($letraContenida) son estas, para vovolver al menu principal digite (S)";
			read dato
			validar_error $dato
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
        fi
}

#Esta parte verifica si el usuario esta registrado y permite el inicio de sesion

while $datoIncorrecto; do
	echo "Ingrese nombre de usuario";

	read nombre;

	echo "Ingrese password";

	read password;

	if grep -q "usuario: *$nombre, *password: *$password" $usuarios; then
		datoIncorrecto=false;
		echo "Inicio de sesion correcto"
		echo "Bienvenido/a $nombre"
		menu_principal;

	else
		datoIncorrecto=true;
		echo "Usuario y/o password no existen"
	fi
done;

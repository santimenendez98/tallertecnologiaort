#!/bin/bash

usuarios="usuarios";

datoIncorrecto=true;

#En esta parte se encuentra la funcion de menu principal con toda su logica dentro

menu_principal(){
	echo "----------------"
	echo "Menu Principal"
	echo "----------------"
	echo "1) Ver lista de usuarios"
	echo "2) Dar de alta un usuario"
	echo "3) Cerrar Sesion"
	read dato

	while [[ $dato != "1" && $dato != "2" && $dato != "3" ]]; do
		echo "Dato ingresado incorrecto"
		read dato
	done;

	if [ $dato = "1" ]; then
		cat $usuarios;
		echo "Para volver digite (S)"
		read salir;
		while [[ $salir != "S" && $salir != "s" ]]; do
			echo "Dato ingresado incorrecto"
                        read salir
		done;
		menu_principal;
	elif [ $dato = "2" ]; then
		echo "Ingrese nombre de nuevo usuario"
		read nuevoNombreUsuario;
		echo "Ingrese password"
		read nuevaPassword;
		nuevoUsuario="{ usuario: $nuevoNombreUsuario, password: $nuevaPassword }"
		if grep -q "usuario: $nuevoNombreUsuario" $usuarios; then
		       	echo "El usuario ya existe"
		       	menu_principal
	       	else
			echo "$nuevoUsuario" >> $usuarios
	 		echo "Usuario creado correctamente"
			menu_principal
		fi		
	elif [ $dato = "3" ]; then
		echo "Estas seguro de cerrar sesion? Ingrese (S) de lo contrario se volvera al menu principal"
		read alerta;
		if [ $alerta = "S" ] || [ $alerta = "s" ]; then
			echo "Sesion cerrada"
		else
			menu_principal
		fi
	fi
}

#Esta parte verifica si el usuario esta registrado y permite el inicio de sesion

while $datoIncorrecto; do
	echo "Ingrese nombre de usuario";

	read nombre;

	echo "Ingrese password";

	read password;

	if grep -q "{ *usuario: *$nombre, *password: *$password *}" $usuarios; then
		datoIncorrecto=false;
		echo "Inicio de sesion correcto"
		echo "Bienvenido/a $nombre"
		menu_principal;
	else
		datoIncorrecto=true;
		echo "Usuario y/o password no existen"
	fi
done;

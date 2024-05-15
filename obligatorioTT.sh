#!/bin/bash
#
#Obligatorio Taller de Tecnologias realizado por: Santiago Menendez Nro.(262188), Ornella Sarantes Nro.(323579), Maria Teresa Nro.()

usuarios="usuarios.txt";
diccionario="diccionario.txt";
registroDiccionario="registroDiccionario.txt";
datoIncorrecto=true;

verificar_salir(){
	local opcion=$1
	while [[ $opcion != "s" && $opcion != "S" ]]; do
        	echo "Dato incorrecto"
                read opcion
        done
	menu_principal
}


#En esta parte se encuentra la funcion de menu principal con toda su logica dentro

menu_principal(){
	clear
	echo "----------------"
	echo "Menu Principal"
	echo "----------------"
	echo "1) Ver lista de usuarios"
	echo "2) Dar de alta un usuario"
	echo "3) Ingresar letra inicial"
	echo "4) Ingresar letra final"
	echo "5) Ingresar letra contenida"
	echo "6) Buscar la palabra"
 	echo "7) Ingresar letra vocal"
	echo "8) Mostrar palabra con vocal del diccionario"
    	echo "9) Palabra capicua"
	echo "10) Ingrese cantidad de datos"
	echo "11) Cerrar Sesion"
	read dato;
	datoNumero=$((dato));

	while [[ $datoNumero -lt 1 || $datoNumero -gt 11 ]]; do
		echo "Dato ingresado incorrecto"
		read dato;
		datoNumero=$((dato));
	done;

	if [ $datoNumero = 1 ]; then
		clear
		cat $usuarios;
		echo "Para volver al menu digite (S)"
		read salir;
		verificar_salir $salir;
	elif [ $datoNumero = 2 ]; then
		clear
		echo "Ingrese nombre de nuevo usuario"
		read nuevoNombreUsuario;
		echo "Ingrese password"
		read nuevaPassword;
		nuevoUsuario="usuario: $nuevoNombreUsuario, password: $nuevaPassword"
		
		if grep -q "usuario: $nuevoNombreUsuario" $usuarios; then
		       	echo "El usuario ya existe"
		       	echo "Para volver al menu digite (S)"
                	read salir;
                	verificar_salir $salir;
	       	else
			echo "$nuevoUsuario" >> $usuarios
	 		echo "Usuario creado correctamente"
			echo "Para volver al menu digite (S)"
                	read salir;
                	verificar_salir $salir;
		fi		
	elif [ $datoNumero = 3 ]; then
		clear
		echo "Ingrese la letra inicial"
		read letraInicial
		while [ ${#letraInicial} -ne 1 ]; do
			echo "La cadena debe contener una sola letra"
			read letraInicial
		done
		echo "Letra inicial guardada"
		echo "Para volver al menu digite (S)"
                read salir;
                verificar_salir $salir;
	elif [ $datoNumero = 4 ]; then
		clear
		echo "Ingrese la letra final"
                read letraFinal
                while [ ${#letraFinal} -ne 1 ]; do
                        echo "La cadena debe contener una sola letra"
                        read letraFinal
                done
                echo "Letra final guardada"
                echo "Para volver al menu digite (S)"
                read salir;
                verificar_salir $salir;
	elif [ $datoNumero = 5 ]; then
		clear
		echo "Ingrese la letra contenida"
                read letraContenida
                while [ ${#letraContenida} -ne 1 ]; do
                        echo "La cadena debe contener una sola letra"
                        read letraContenida
                done
                echo "Letra contenida guardada"
                echo "Para volver al menu digite (S)"
                read salir;
                verificar_salir $salir;
	elif [ $datoNumero = 6 ]; then

		#Opcion para devolver palabras del diccionario que cumplen con la opcion 4,5 y 6. Aparte crea un registro dentro del archivo registroDiccionario.txt
		clear
		verificarPrimerLetra="${letraInicial:0:1}"
		verificarUltimaletra="${letraFinal: -1}"
		verificarLetraContenida="$letraContenida"

		if [ ${#letraInicial} -ne 1 ] || [ ${#letraFinal} -ne 1 ] || [ ${#letraContenida} -ne 1 ]; then
			echo "Se debe ingresar todos los datos antes de buscar la palabra"
			echo "Para volver al menu digite (S)"
			read salir
			verificar_salir $salir
		else
			fecha=$(date +"%Y-%m-%d")
            		palabrasEncontradas=$(grep -c "^$verificarPrimerLetra.*$verificarUltimaletra.*$verificarLetraContenida" $diccionario)
            		palabrasDiccionario=$(grep -c "" $diccionario)
					porcentaje=$(bc <<< "scale=2; ($palabrasEncontradas * 100 / $palabrasDiccionario)")
            		registro="Fecha de busqueda: $fecha, Cantidad de palabras encontradas: $palabrasEncontradas, Total de palabras del diccionario: $palabrasDiccionario, Porcentaje de palabras encontradas: $porcentaje%, Usuario: "$nombre""
            		grep "^$verificarPrimerLetra.*$verificarLetraContenida.*$verificarUltimaletra$" $diccionario;
            		echo "$registro" >> $registroDiccionario
			echo "Las palabras que inician con ($letraInicial), terminan con ($letraFinal) y contienen la letra ($letraContenida) son estas, para vovolver al menu principal digite (S)";
			read salir
                	verificar_salir $salir;
		fi
	elif  [ $datoNumero = 7 ]; then
		clear
        	echo "Ingrese la letra vocal"
        	read letraVocal
        	while [ ${#letraVocal} -ne 1 ] || [ $letraVocal != "a" ] && [ $letraVocal != "e" ] && [ $letraVocal != "i" ] && [ $letraVocal != "o" ] && [ $letraVocal != "u" ] && [ $letraVocal != "A" ] && [ $letraVocal != "E" ] && [ $letraVocal != "I" ] && [ $letraVocal != "O" ] && [ $letraVocal != "U" ]; do 
                	echo "La cadena debe contener una sola letra y debe ser vocal"
                	read letraVocal
        	done
        	echo "Letra vocal guardada"
        	echo "Para volver al menu digite (S)"
                read salir;
                verificar_salir $salir;
	elif [ $datoNumero = 8 ]; then
		clear
		if [ -z "$letraVocal" ]; then
			echo "Debe ingresar una letra vocal en la opcion 7"
			echo "Para volver al menu digite (S)"
                	read salir;
                	verificar_salir $salir;
		else
        		echo "Estas son las palabras del diccionario que contienen unicamente la vocal $letraVocal"
        		grep -i "^[^aeiou]*[$letraVocal][^aeiou]*$" $diccionario
        		echo "Para volver al menu digite (S)"
                	read salir;
                	verificar_salir $salir;
		fi
	elif [ $datoNumero = 9 ]; then
		clear
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
		echo "Para volver al menu ingrese (S)"
		read salir
                verificar_salir $salir
	elif [ $datoNumero = 10 ]; then 
		clear 
		echo "Ingrese cantidad de datos" 
		read cantidad
    		echo "Ingrese dato 1"
    		read primerDato
    		mayor=$primerDato
    		menor=$primerDato
   		suma=$primerDato
    		contador=1
		promedio=0
    		for (( i=2; i<=$cantidad; i++ )); do
        		echo "Ingrese dato $i"
        		read dato
        		suma=$((suma + dato))
        		contador=$((contador + 1))
        		if [ $dato -gt $mayor ]; then
            			mayor=$dato
        		elif [ $dato -lt $menor ]; then
            			menor=$dato
        		fi
		done
		promedio=$((suma / contador))
		echo "El promedio es: $promedio, el mayor es: $mayor y el menor es: $menor"
		echo "Para volver al menu ingrese (S)"
		read salir
		verificar_salir $salir	
	elif [ $datoNumero = 11 ]; then
		clear
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

	read -rs password;

	if grep -q "usuario: *$nombre, *password: *$password" $usuarios; then
		datoIncorrecto=false;
		echo "Inicio de sesion correcto"
		echo "Bienvenido/a $nombre"
		menu_principal "$nombre";

	else
		datoIncorrecto=true;
		clear
		echo "Usuario y/o password no existen"
	fi
done;

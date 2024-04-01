{ Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
 creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
 promedio de los números ingresados. El nombre del archivo a procesar debe ser
 proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
 contenido del archivo en pantalla.
}


program Ejercicio2;

const
	condicion = 1500;

type
	archivo_numeros = file of integer;

function procesar_nombre: string;
var
	nombre_fisico: string;
begin
	write('Ingrese el nombre del archivo:');
	readln(nombre_fisico);
	procesar_nombre:= nombre_fisico;
end;

procedure procesar_archivo (var numeros: archivo_numeros);
var
	total, cant_menores, num: integer;
begin
	reset(numeros);
	
	total:= 0; cant_menores:= 0;
	while not EOF(numeros) do begin
		read(numeros, num);
		total:= total+num;
		if (num < condicion) then cant_menores:= cant_menores+1;
		write(num);
		writeln;
	end;
	
	writeln;
	write('La cantidad de numeros menores a ', condicion, ' es de: ', cant_menores);
	writeln;
	write('El promedio de los numeros ingresados es:', total/fileSize(numeros):10:2);
	
	close(numeros);
end;

var
	numeros: archivo_numeros;

BEGIN
	assign(numeros, procesar_nombre);
	
	procesar_archivo (numeros);	
END.

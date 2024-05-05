{ 2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}


program Ejercicio2;

const
	valor_alto = 9999;
	
type
	reg_alumno = record
		codigo: integer;
		apellido: string[20];
		nombre: string[20];
		cursadas: integer;
		finales: integer;
	end;
	
	reg_materia = record
		codigo: integer;
		cursadaA: boolean;
		finalA: boolean;
	end;
	
	archivo_alumnos = file of reg_alumno;
	archivo_detalle = file of reg_materia;

procedure leer (var detalle: archivo_detalle; var materia: reg_materia);
begin
	if not EOF(detalle) then read(detalle, materia)
	else
		materia.codigo:= valor_alto;
end;

procedure crearArchivos (var alumnos: archivo_alumnos; var detalle: archivo_detalle);
var
	alumno: reg_alumno; materia: reg_materia;
	
begin
	rewrite(alumnos);
	rewrite(detalle);
	
	alumno.codigo:= 1;
	alumno.apellido:= 'Nunez';
	alumno.nombre:= 'Valentin';
	alumno.cursadas:= 2;
	alumno.finales:= 6;
	write(alumnos, alumno);
	alumno.codigo:= 2;
	alumno.apellido:= 'Eguaras';
	alumno.nombre:= 'Zoe';
	alumno.cursadas:= 1;
	alumno.finales:= 3;
	write(alumnos, alumno);
	
	materia.codigo:= 1;
	materia.cursadaA:= true;
	materia.finalA:= true;
	write(detalle, materia);
	materia.codigo:= 1;
	materia.cursadaA:= true;
	materia.finalA:= false;
	write(detalle, materia);
	materia.codigo:= 1;
	materia.cursadaA:= true;
	materia.finalA:= true;
	write(detalle, materia);
	materia.codigo:= 2;
	materia.cursadaA:= true;
	materia.finalA:= false;
	write(detalle, materia);
	materia.codigo:= 2;
	materia.cursadaA:= false;
	materia.finalA:= false;
	write(detalle, materia);
	materia.codigo:= 2;
	materia.cursadaA:= true;
	materia.finalA:= true;
	write(detalle, materia);
	
	close(detalle);
	close(alumnos);
end;

procedure actualizarMaestro (var alumnos: archivo_alumnos; var detalle: archivo_detalle);
var
	alumno: reg_alumno; materia: reg_materia;
	
begin
	reset(alumnos);
	reset(detalle);
	
	leer(detalle, materia);
	while (materia.codigo <> valor_alto) do begin
		read(alumnos, alumno);
		while (alumno.codigo <> materia.codigo) do begin
			read(alumnos, alumno);
		end;
		while (alumno.codigo = materia.codigo) do begin
			if (materia.finalA) then begin
				alumno.cursadas:= alumno.cursadas - 1;
				alumno.finales:= alumno.finales + 1;
			end
			else if (materia.cursadaA) then alumno.cursadas:= alumno.cursadas + 1;
			leer(detalle, materia);
		end;
		seek(alumnos, filePos(alumnos)-1);
		write(alumnos, alumno);	 
	end;
	
	writeln(#10, 'Maestro actualizado con exito.', #10);
	close(alumnos);
	close(detalle);
end;

procedure listarTexto (var alumnos: archivo_alumnos);
var
	txt: text; alumno: reg_alumno;
	
begin
	assign(txt, 'Listado de Alumnos.txt');
	reset(alumnos);
	rewrite(txt);
	
	while not EOF(alumnos) do begin
		read(alumnos, alumno);
		if (alumno.cursadas < alumno.finales) then 
			writeln(txt, 'Codigo: ', alumno.codigo, ' Apellido: ', alumno.apellido, ' Nombre: ', alumno.nombre, ' Cursadas Aprobadas: ', alumno.cursadas, ' Finales Aprobados: ', alumno.finales);
	end;

	writeln(#10, 'Listado creado con exito.', #10);
	close(txt);
	close(alumnos);
end;

var
	alumnos: archivo_alumnos; detalle: archivo_detalle; opcion: integer;

BEGIN
	assign(alumnos, 'alumnos');
	assign(detalle, 'detalle');
	
	repeat
		writeln('------- MENU -------');
		writeln('1. Crear archivos (para probarlo).');
		writeln('2. Actualizar archivo maestro.');
		writeln('3. Listar en texto a los alumnos que tengan más materias con finales aprobados que materias sin finales aprobados.');
		writeln('4. Salir.');
		readln(opcion);
		
		case opcion of
			1: crearArchivos(alumnos, detalle);
			2: actualizarMaestro(alumnos, detalle);
			3: listarTexto(alumnos);
			4: writeln(#10, 'Cerrando aplicacion...');
		else writeln(#10, 'Opcion invalida. Intente de nuevo.');
		end;
		
	until (opcion = 4);
END.


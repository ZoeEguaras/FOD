{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:

a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
 
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.

c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
}


program Ejercicio8;

const
	valor_alto = 'ZZZZ';

type
	reg_distribucion = record
		nombre: string;
		lanzamiento: integer;
		version: real;
		desarrolladores: integer;
		descripcion: string;
	end;
	
	archivo_linux = file of reg_distribucion;
	
procedure leerDistribucion (var linux: archivo_linux; var reg: reg_distribucion);
begin
	if not EOF(linux) then read(linux, reg)
	else reg.nombre:= valor_alto;
end;

function existeDistribucion (var linux: archivo_linux; nombre: string): boolean;
var
	distribucion: reg_distribucion; found: boolean;
	
begin
	reset(linux);
	found:= false;
	
	leerDistribucion(linux, distribucion);
	while (distribucion.nombre <> valor_alto) and not found do begin
		if (distribucion.nombre = nombre) then found:= true
		else
			leerDistribucion(linux, distribucion);
	end;
	
	close(linux);
	existeDistribucion:= found; 
end;

procedure cargarDistribucion (var distribucion: reg_distribucion);
begin
	write('Ingrese nombre: ');
	readln(distribucion.nombre);
	write('Ingrese year de lanzamiento: ');
	readln(distribucion.lanzamiento);
	write('Ingrese numero de version de kernel: ');
	readln(distribucion.version);
	write('Ingrese cantidad de desarrolladores: ');
	readln(distribucion.desarrolladores);
	write('Ingrese descripcion: ');
	readln(distribucion.descripcion);
	writeln;
end;

procedure cargarArchivo (var linux: archivo_linux);
var
	distribucion: reg_distribucion;
	
begin
	rewrite(linux);
	
	distribucion.desarrolladores:= 0;
	write(linux, distribucion);
	writeln(#10, 'CARGANDO ARCHIVO...');

	distribucion.nombre := 'Ubuntu';
    distribucion.lanzamiento := 2004;
    distribucion.version := 5.4;
    distribucion.desarrolladores := 800;
    distribucion.descripcion := 'Distribucion Linux basada en Debian, enfocada en la facilidad de uso.';
    write(linux, distribucion);

    distribucion.nombre := 'Fedora';
    distribucion.lanzamiento := 2003;
    distribucion.version := 5.10;
    distribucion.desarrolladores := 1400;
    distribucion.descripcion := 'Distribucion comunitaria respaldada por Red Hat, con un enfoque en la innovacion.';
    write(linux, distribucion);

    distribucion.nombre := 'Debian';
    distribucion.lanzamiento := 1993;
    distribucion.version := 5.10;
    distribucion.desarrolladores := 1500;
    distribucion.descripcion := 'Distribucion estable y ampliamente utilizada, conocida por su sistema de gestion de paquetes.';
    write(linux, distribucion);

    distribucion.nombre := 'CentOS';
    distribucion.lanzamiento := 2004;
    distribucion.version := 4.18;
    distribucion.desarrolladores := 300;
    distribucion.descripcion := 'Distribucion de codigo abierto basada en el codigo fuente de Red Hat Enterprise Linux.';
    write(linux, distribucion);

    distribucion.nombre := 'Arch Linux';
    distribucion.lanzamiento := 2002;
    distribucion.version := 5.12;
    distribucion.desarrolladores := 50;
    distribucion.descripcion := 'Distribucion ligera y flexible, enfocado a usuarios avanzados.';
    write(linux, distribucion);
	
	writeln(#10, 'Carga finalizada con exito.');
	close(linux);
end;

procedure altaDistribucion (var linux: archivo_linux);
var
	distribucion, cabecera: reg_distribucion; pos: integer;
	
begin
	cargarDistribucion(distribucion);
	if existeDistribucion(linux, distribucion.nombre) then writeln(#10, 'Ya existe la distribucion ingresada.')
	else begin
		reset(linux);
		leerDistribucion(linux, cabecera);
		if (cabecera.desarrolladores = 0) then begin
			seek(linux, fileSize(linux));
			write(linux, distribucion);
		end
		else begin
			pos:= cabecera.desarrolladores * -1;
			seek(linux, pos);
			read(linux, cabecera);
			seek(linux, pos);
			write(linux, distribucion);
			seek(linux, 0);
			write(linux, cabecera);
		end;
		writeln(#10, 'Distribucion agregada con exito.');
		close(linux);
	end;
end;

procedure bajaDistribucion (var linux: archivo_linux);
var
	distribucion, cabecera: reg_distribucion; nombre: string; found: boolean;
	pos: integer;
	
begin
	write('Ingrese nombre: ');
	readln(nombre);
	if existeDistribucion(linux, nombre) then begin
		reset(linux);
		leerDistribucion(linux, cabecera);
		leerDistribucion(linux, distribucion);
		found:= false;
		while not found do begin
			if (distribucion.nombre = nombre) then found:= true
			else leerDistribucion(linux, distribucion);
		end;
		pos:= filePos(linux) - 1;
		distribucion.desarrolladores:= pos * -1;
		seek(linux, pos);
		write(linux, cabecera);
		seek(linux, 0);
		write(linux, distribucion);
		writeln(#10, 'Distribucion eliminada con exito.');
		close(linux);
	end
	else writeln(#10, 'Distribucion no existente.');
end;

procedure imprimirDistribucion (distribucion: reg_distribucion);
begin
	writeln('Nombre: ', distribucion.nombre);
	writeln('Year de Lanzamiento: ', distribucion.lanzamiento);
	writeln('Codigo de version de kernel: ', distribucion.version:3:3);
	writeln('Cantidad de desarrolladores: ', distribucion.desarrolladores);
	writeln('Descripcion: ', distribucion.descripcion);
	writeln;
end;

procedure imprimirArchivo (var linux: archivo_linux);
var
	distribucion: reg_distribucion;
	
begin
	reset(linux);
	leerDistribucion(linux, distribucion); // Salteo la cabecera
	
	leerDistribucion(linux, distribucion);
	writeln (#10, '--------- DISTRIBUCIONES ---------');
	while (distribucion.nombre <> valor_alto) do begin
		if (distribucion.desarrolladores > 0) then imprimirDistribucion(distribucion);
		leerDistribucion(linux, distribucion);
	end;
		
	close(linux);
end;

procedure imprimirArchivoCompleto (var linux: archivo_linux);
var
	distribucion: reg_distribucion;
	
begin
	reset(linux);
	
	leerDistribucion(linux, distribucion);
	writeln (#10, '--------- DISTRIBUCIONES ---------');
	while (distribucion.nombre <> valor_alto) do begin
		imprimirDistribucion(distribucion);
		leerDistribucion(linux, distribucion);
	end;
		
	close(linux);
end;


var
	linux: archivo_linux; opcion: integer;

BEGIN
	// Cargo el archivo para probar
	assign(linux, 'Archivo Distribuciones');
	cargarArchivo(linux);
	
	repeat
		writeln(#10, '--------- MENU ---------');
		writeln('1. Agregar distribucion.');
		writeln('2. Eliminar distribucion.');
		writeln('3. Listar distribuciones.');
		writeln('4. Listar contenidos.');
		writeln('5. Cerrar menu.');
		readln(opcion);
		
		case opcion of
			1: altaDistribucion(linux);
			2: bajaDistribucion(linux);
			3: imprimirArchivo(linux);
			4: imprimirArchivoCompleto(linux);
			5: writeln(#10, 'Cerrando...')
		else writeln(#10, 'El numero ingresado no corresponde con ninguna opcion. Intenta de nuevo.');
		end;
	until opcion = 5;
END.


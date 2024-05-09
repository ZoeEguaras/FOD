{7. Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}


program Ejercicio7;

const
	valor_alto = 99999;
	corte = 500000;
	
type
	reg_ave = record
		codigo: longInt;
		nombre: string;
		familia: string;
		descripcion: string;
		zona: string;
	end;
	
	archivo_aves = file of reg_ave;
	
procedure leerAve (var archivo: archivo_aves; var ave: reg_ave);
begin
	if not EOF(archivo) then read(archivo, ave)
	else begin
		ave.codigo:= valor_alto;
	end;
end;

procedure crearArchivo (var archivo: archivo_aves);
var
	ave: reg_ave;

begin
	assign(archivo, 'Archivo Aves');
	rewrite(archivo);
	
	// Ave 1
    ave.codigo := 34;
    ave.nombre := 'Struthio camelus';
    ave.familia := 'Struthionidae';
    ave.descripcion := 'El avestruz comun es un ave no voladora, perteneciente al orden Struthioniformes. Es el ave mas grande del mundo. Tiene una altura de 2,5 a 2,8 m y un peso de 100 a 160 kg.';
    ave.zona := 'Africa';
    write(archivo, ave);
    
    // Ave 2
    ave.codigo := 23;
    ave.nombre := 'Aquila chrysaetos';
    ave.familia := 'Accipitridae';
    ave.descripcion := 'El aguila real es una especie de ave accipitriforme de la familia Accipitridae. Es uno de los mayores y mas poderosos cazadores de aves de presa, con una envergadura que puede alcanzar los 2,2 metros.';
    ave.zona := 'America del Norte, Europa, Asia';
    write(archivo, ave);
    
    // Ave 3
    ave.codigo := 12;
    ave.nombre := 'Gallus gallus domesticus';
    ave.familia := 'Phasianidae';
    ave.descripcion := 'El gallo domestico es una especie de ave galliforme de la familia Phasianidae. Es uno de los animales mas comunes y extendidos por todo el mundo.';
    ave.zona := 'Sureste de Asia';
    write(archivo, ave);
    
    // Ave 4
    ave.codigo := 67;
    ave.nombre := 'Corvus corax';
    ave.familia := 'Corvidae';
    ave.descripcion := 'El cuervo comun es una especie de ave paseriforme de la familia Corvidae. Es una de las aves mas inteligentes y se distribuye por todo el Hemisferio Norte.';
    ave.zona := 'Hemisferio Norte';
    write(archivo, ave);
    
    // Ave 5
    ave.codigo := 56;
    ave.nombre := 'Pavo cristatus';
    ave.familia := 'Phasianidae';
    ave.descripcion := 'El pavo real comun es una especie de ave galliforme de la familia Phasianidae. Es conocido por su esplendido plumaje utilizado para el cortejo.';
    ave.zona := 'India, Sri Lanka';
    write(archivo, ave);
    
    // Ave 6
    ave.codigo := 89;
    ave.nombre := 'Columba livia';
    ave.familia := 'Columbidae';
    ave.descripcion := 'La paloma bravia es una especie de ave columbiforme de la familia Columbidae. Es la especie de paloma domestica derivada de la paloma zurita, de la cual descienden todas las palomas domesticas actuales.';
    ave.zona := 'Mundial';
    write(archivo, ave);
    
    // Ave 7
    ave.codigo := 75;
    ave.nombre := 'Sturnus vulgaris';
    ave.familia := 'Sturnidae';
    ave.descripcion := 'La estornino pinto es una especie de ave paseriforme de la familia Sturnidae. Es un ave muy adaptable y se encuentra en una amplia gama de habitats.';
    ave.zona := 'Eurasia, norte de Africa';
    write(archivo, ave);
	
	close(archivo);
end;

procedure imprimirAve (ave: reg_ave);
begin
	writeln('Codigo: ', ave.codigo);
	writeln('Nombre: ', ave.nombre);
	writeln('Familia: ', ave.familia);
	writeln('Descripcion: ', ave.descripcion);
	writeln('Zona: ', ave.zona);
	writeln;
end;

procedure imprimirArchivo (var archivo: archivo_aves);
var
	ave: reg_ave;
	
begin
	reset(archivo);
	
	writeln(#10, '----------- AVES ALMACENADAS -----------');
	leerAve(archivo, ave);
	while (ave.codigo <> valor_alto) do begin
		imprimirAve(ave);
		leerAve(archivo, ave);
	end;
	
	close(archivo);
end;

procedure marcarAve (var archivo: archivo_aves; codigo: longInt);
var
	ave: reg_ave;
	
begin
	reset(archivo);
	
	leerAve(archivo, ave);
	while (ave.codigo <> valor_alto) and (ave.codigo <> codigo) do begin
		leerAve(archivo, ave);
	end;
	if (ave.codigo = codigo) then begin
		ave.codigo:= ave.codigo * -1;
		seek(archivo, filePos(archivo) - 1);
		write(archivo, ave);
		writeln(#10, 'Ave ', codigo, ' marcada con exito.');
	end
	else writeln(#10, 'Ave ', codigo, ' no encontrada.');
	
	close(archivo);
end;

procedure eliminarAvesMarcadas (var archivo: archivo_aves);
var
	ave: reg_ave; pos: integer;
	
begin
	reset(archivo);
	
	leerAve(archivo, ave);
	while (ave.codigo <> valor_alto) do begin
		if (ave.codigo < 0) then begin
			pos:= filePos(archivo) - 1;
			if (pos < fileSize(archivo) - 1) then begin // Si no es el ultimo
				seek(archivo, fileSize(archivo) - 1);
				read(archivo, ave);
				seek(archivo, pos);
				write(archivo, ave);
				seek(archivo, fileSize(archivo) - 1);
				truncate(archivo);
				seek(archivo, pos);
			end
			else begin // Si es el ultimo
				seek(archivo, pos);
				truncate(archivo);
			end;
		end
		leerAve(archivo, ave);
	end;
	
	writeln(#10, 'Limpieza finalizada con exito.');
	close(archivo);
end;


var
	archivo: archivo_aves; codigo: longInt;

BEGIN
	// Creo el archivo para probar el funcionamiento
	crearArchivo(archivo);
	imprimirArchivo(archivo);
	
	// Se leen los datos y se eliminan
	write('Ingrese el codigo del ave a eliminar: ');
	readln(codigo);
	while (codigo <> corte) do begin
		marcarAve(archivo, codigo);
		write(#10, 'Ingrese el codigo del ave a eliminar: ');
		readln(codigo);
	end;
	
	// Chequeo que se haya marcado bien
	imprimirArchivo(archivo);
	
	// Compacto el archivo
	eliminarAvesMarcadas(archivo);
	
	// Chequeo que se hayan eliminado bien
	imprimirArchivo(archivo);
END.


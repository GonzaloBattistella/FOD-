{
  7. Realizar un programa que permita: 
  
  a) Crear un archivo binario a partir de la información almacenada en un archivo de 
  texto. El nombre del archivo de texto es: “novelas.txt”. La información en el 
  archivo de texto consiste en: código  de novela, nombre, género y precio de 
  diferentes novelas argentinas. Los datos de cada novela se almacenan en dos 
  líneas en el archivo de texto. La primera línea contendrá la siguiente información: 
  código novela, precio y género, y la segunda línea almacenará el nombre de la 
  novela. 

  b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder 
  agregar una novela y modificar una existente. Las búsquedas se realizan por 
  código de novela. 

  NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado. 
}


program Ejercicio7;
type
  novela = record
    codigo:integer;
    nombre:string;
    genero:string;
    precio:real;
  end;
  
  tArch = File of novela;

//PROCESOS
procedure mostrarMenuPrincipal();
begin
  writeln(' ');
  writeln('------------------------------------');
  writeln('MENU PRINCIPAL');
  writeln('------------------------------------');
  writeln('1. Cargar Archivo Binario.');
  writeln('2. Agregar Novela.');
  writeln('3. Modificar Novela.');
  writeln('4. Listar Novelas.');
  writeln('5. Salir.');
  writeln('------------------------------------');
  writeln(' ');
end;

//CARGAR ARCHIVO 
procedure cargarArchivo(var a:tArch);
var
  at:Text; //Archivo de Texto.
  n:novela;
begin
  rewrite(a); //Creo el archivo binario. Si existe se sobreescribe.
  assign(at, 'novelas.txt');
  reset(at); //Abro el archivo de texto.
  
  while not EOF(at) do begin
    //Leo la novela del .txt
    readln(at, n.codigo, n.precio, n.genero); //1°Linea
    readln(at, n.nombre); //2° Linea
    
    write(a, n); //Escribo la novela en el archivo binario.
  end;
  
  writeln('Archivo binario cargado Exitosamente!');
  
  //Cierro los archivos.
  close(at);
  close(a);
end;

//AGREGAR NOVELA
procedure agregarNovela(var a:tArch);

    //LEER NOVELA
    procedure leerNovela(var n:novela);
    begin
      writeln(' ');
      writeln('------------------------------------');
      writeln('Ingrese el codigo de Novela: ');
      readln(n.codigo);
      writeln('Ingrese el Nombre de la novela: ');
      readln(n.nombre);
      writeln('Ingrese el genero de la novela: ');
      readln(n.genero);
      writeln('Ingrese el precio de la novela: ');
      readln(n.precio);
      writeln('------------------------------------');
      writeln(' ');
    end;

var
  n:novela;
begin
  reset(a); //Abro el archivo.
  leerNovela(n);
  seek(a, fileSize(a)); //Me muevo al final del archivo.
  write(a, n);
  writeln('Novela Agregada Exitosamente!');
  close(a); //Cierro el archivo.
end;
//PROCESOS

//MODIFICAR NOVELA
procedure modificarNovela(var a:tArch);

    //LEER NUEVOS DATOS.
    procedure leerNuevosDatos(var n:novela);
    begin
      writeln(' ');
      writeln('Ingrese el nuevo nombre de la novela: ');
      readln(n.nombre);
      writeln('Ingrese el nuevo codigo de la novela: ');
      readln(n.codigo);
      writeln('Ingrese el nuevo genero de la novela: ');
      readln(n.genero);
      writeln('Ingrese el nuevo precio de la novela: ');
      readln(n.precio);
      writeln(' ');
    end;
    
var
  n:novela;
  codigoNovela:Integer;
  encontre:boolean;
begin
  encontre:= false;
  
  writeln('Ingrese el codigo de la novela a Modificar: ');
  readln(codigoNovela);
  reset(a); //Abro el archivo.
  
  while not EOF(a) do begin
    read(a, n); //Leo una novela.
    
    if(codigoNovela = n.codigo)then begin
      leerNuevosDatos(n); //Leo los datos nuevos de la novela a modificar.
      seek(a, filePos(a) - 1); //Me muevo una posicion para atras para posicionarme en la novela correspondiente.
      write(a, n); //Escribo la novela modificada en el archivo.
      encontre:= true;
      writeln('Novela modificada con Exito!');
    end;
  end;
  
  if not encontre then writeln('No se encontro la novela ingresada.');
  
  close(a); //Cierro el Archivo.
end;

//MOSTRAR NOVELAS
procedure mostrarNovelas(var a:tArch);

  //IMPRIMIR NOVELA
  procedure imprimirNovela(n:novela);
  begin
    with n do begin
      writeln('Codigo: ', codigo);
      writeln('Nombre: ', nombre);
      writeln('Genero: ', genero);
      writeln('Precio: ', precio:0:2);
      writeln(' ');
      writeln('------------------------------------------------');
    end;
  end;

var
  n:novela;
begin
  reset(a); //Abro el archivo
  
  writeln(' ');
  writeln('--------------------------------------------------');
  writeln('NOVELAS');
  writeln('--------------------------------------------------');
  
  //Recorro el archivo.
  while not EOF(a) do begin
    read(a, n); //Leo una novela
    imprimirNovela(n); //Muestro la novela leida en pantalla.
  end;
  
  close(a); //Cierro el Archivo.
end;

//PROGRAMA PRINCIPAL
var
  a:tArch;
  nomArch:string;
  opcion:integer;
BEGIN
	writeln('Ingrese el nombre del archivo. ');
  readln(nomArch);
  assign(a, nomArch);
  
  mostrarMenuPrincipal();
  writeln(' ');
  writeln('Ingrese una opcion: ');
  readln(opcion);
  
  while (opcion <> 5)do begin
    case opcion of
      1: cargarArchivo(a);
      2: agregarNovela(a);
      3: modificarNovela(a);
      4: mostrarNovelas(a)
    else
      writeln('Opcion Invalida. Intentelo Nuevamente.');
    end;
    
    mostrarMenuPrincipal();
    writeln(' ');
    writeln('Ingrese una opcion: ');
    readln(opcion);
  end;
  
  writeln('Saliendo del Programa...');
END.

{
  5. Realizar un programa para una tienda de celulares, que presente un menú con 
  opciones para: 

  a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos 
  ingresados desde un archivo de texto denominado “celulares.txt”. Los registros 
  correspondientes a los celulares deben contener: código de celular, nombre, 
  descripción, marca, precio, stock mínimo y stock disponible. 

  b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al 
  stock mínimo. 

  c. Listar en pantalla los celulares del archivo cuya descripción contenga una 
  cadena de caracteres proporcionada por el usuario. 

  d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado 
  “celulares.txt” con todos los celulares del mismo. El archivo de texto generado 
  podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que 
  debería respetar el formato dado para este tipo de archivos en la NOTA 2. 

  NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el 
  usuario. 

  NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique 
  en tres  líneas consecutivas. En la primera se especifica: código de celular,  el precio y 
  marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera 
  nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo 
  “celulares.txt”.
  * 
  * 
  6. Agregar al menú del programa del ejercicio 5, opciones para: 

  a. Añadir uno o más celulares al final del archivo con sus datos ingresados por 
  teclado. 

  b. Modificar el stock de un celular dado. 

  c. Exportar el contenido del archivo binario a un archivo de texto denominado: 
  ”SinStock.txt”, con aquellos celulares que tengan stock 0. 

  NOTA: Las búsquedas deben realizarse por nombre de celular.
}


program Ejercicio5y6;

uses SysUtils; //Necesario para poder usar lowerCase. lowerCase() pasa un cadena de texto a minusculas. 

type
  celular = record
    codigo:integer;
    nombre:string;
    desc:string;
    marca:string;
    precio:real;
    stock_min:integer;
    stock_disp:integer;
  end;
  
  tArch = File of celular;

//PROCESOS
procedure mostrarMenu();
begin
  writeln(' ');
  writeln('-----------------------------------------');
  writeln('MENU');
  writeln('-----------------------------------------');
  writeln('1. Cargar archivo. ');
  writeln('2. Listar celulares con Stock menor al Stock Minimo.');
  writeln('3. Listar celulares por coincidencia en la descripcion. ');
  writeln('4. Exportar celulares a .txt.');
  writeln('5. Agregar celular. ');
  writeln('6. Modificar Stock. ');
  writeln('7. Exportar a .txt celulares con Stock 0.');
  writeln('8. Salir.');
  writeln('-----------------------------------------');
end;

//CARGAR ARCHIVO: Cargar un archivo binario en base a un archivo .txt
procedure cargarArchivo(var a:tArch);
var
  at: Text; //Archivo de Texto.
  c:celular;
begin
  assign(at, 'celulares.txt');
  reset(at);
  rewrite(a); //Creo el archivo. Si existe se sobreescribe.
  
  while not EOF (at) do begin
    //Leo un celular del txt, con el formato solicitado.
    readln(at, c.codigo, c.precio, c.marca);
    readln(at, c.stock_disp, c.stock_min, c.desc);
    readln(at, c.nombre);
    
    write(a, c); //Escribo el celular en el archivo binario.
  end;
  
  //Cierro los archivos
  close(a);
  close(at);
  
  writeln('Archivo Cargado Exitosamente! ');
end;

//MOSTRAR CELULAR
procedure mostrarCelular(c:celular);
begin
  writeln(' ');
  writeln('Marca: ', c.marca);
  writeln('Nombre: ', c.nombre);
  writeln('Codigo: ', c.codigo);
  writeln('Precio: ', c.precio:0:2);
  writeln('Stock Disponible: ', c.stock_disp);
  writeln('Stock Minimo: ', c.stock_min);
  writeln('Descripcion: ', c.desc);
  writeln('---------------------------------------');
  writeln(' ');
end;

//LISTAR CELULARES STOCK MENOR AL MINIMO.
procedure listarCelularesStockMenorAMinimo(var a:tArch);
var
  c:celular;
  encontre:boolean;
begin
  encontre:= false;
  reset(a); //Abro el archivo. 
  
  writeln(' ');
  writeln('-----------------------------------------');
  writeln('CELULARES STOCK MENOR AL MINIMO');
  writeln('-----------------------------------------');
  
  while not EOF(a) do begin
    read(a, c); //Leo un celular del archivo.
    
    if(c.stock_disp < c.stock_min)then begin
      mostrarCelular(c);
      encontre:= true;
    end;
  end;
  
  //Si no hay celulares que mostrar, informo.
  if not (encontre) then writeln('No hay celulares con Stock menor al Stock minimo. ');
  
  close(a); //Cierro el archivo.
end;

//LISTAR CELULARES MATCH DESCRIPCION
procedure listarCelularesMatchDescripcion(var a:tArch);
var
  c:celular;
  cadena: string;
  encontre: boolean;
begin
  writeln(' ');
  writeln('Ingrese el Fragmento a buscar en la Descripcion: ');
  readln(cadena);
  encontre:= false;
  
  //Convierto la cadena ingresada por el usuario a minusculas, para evitar problemas con mayusculas y minusculas.
  cadena:= LowerCase(cadena); 
  
  reset(a); //Abro el archivo.
  
  while not EOF(a) do begin
    read(a, c); //Leo un celular.
    
    // Pos(): Es una funcion de Pascal que devuelve la posición de la primera aparición de la subcadena "cadena" dentro de la descripcion. Si no encuentra la subcadena, devuelve 0.
    if (Pos(cadena, LowerCase(c.desc)) <> 0)then begin
      mostrarCelular(c);
      encontre:= true; //Se encontro al menos una coincidencia.
    end;
  end;
  
  if not (encontre) then writeln('No se encontraron celulares con esa descripcion. ');
  
  close(a);
end;

//EXPORTAR CELULARES .TXT
procedure exportarCelularesTxt(var a:tArch);
var
  at:Text; //Archivo de Texto.
  c:celular;
begin
  assign(at, 'celulares.txt');
  rewrite(at); //Si el archivo existe, se sobreescribe.
  reset(a); //Abro el archivo binario.
  
  while not EOF(a) do begin
    read(a, c); //Leo un celular.
    
    //Escribo en el formato solicitado en el txt.
    writeln(at, c.codigo,' ', c.precio:0:2,' ', c.marca); //1° Linea 
    writeln(at, c.stock_disp,' ', c.stock_min,' ', c.desc); //2° Linea
    writeln(at, c.nombre); //3° Linea
  end;
  
  //Cierro los archivos.
  close(a);
  close(at);
  
  writeln('Celulares Exportados Correctamente!');
end;

//AGREGAR CELULAR
procedure agregarCelular(var a:tArch);

  //LEER CELULAR
  procedure leerCelular(var c:celular);
  begin
    writeln(' ');
    writeln('--------------------------------------------------');
    writeln('Ingrese la marca del celular: ');
    readln(c.marca);
    writeln('Ingrese el nombre del celular: ');
    readln(c.nombre);
    writeln('Ingrese el codigo del celular: ');
    readln(c.codigo);
    writeln('Ingrese el precio del celular: ');
    readln(c.precio);
    writeln('Ingrese el Stock Disponible del celular: ');
    readln(c.stock_disp);
    writeln('Ingrese el Stock Minimo de celular: ');
    readln(c.stock_min);
    writeln('Ingrese la descripcion del celular: ');
    readln(c.desc);
    writeln('--------------------------------------------------');
    writeln(' ');
  end;

var
  c:celular;
begin
  reset(a); //Abro el archivo.
  leerCelular(c); //Leo los datos de un celular ingresados por teclado.
  seek(a, fileSize(a)); //Me posiciono al final del archivo.
  write(a, c); //Escribo el nuevo celular all final del archivo.
  writeln(' ');
  writeln('Celular Agregado Exitosamente! ');
  close(a); //Cierro el archivo.
end;

//MODIFICAR STOCK
procedure modificarStock(var a:tArch);
var
  new_stock:integer;
  nomCel: String;
  c:celular;
  encontre: boolean;
begin
  writeln(' ');
  writeln('Ingrese el nombre del celular a modificar el Stock.');
  readln(nomCel);
  writeln(' ');
  
  encontre:= false;
  reset(a); //Abro el archivo
  
  while not EOF(a) and not encontre do begin
    read(a, c); //Leo un celular
    
    if(nomCel = c.nombre)then begin
      encontre:= true;
      writeln('Ingrese el nuevo stock: ');
      readln(new_stock); //Nuevo valor del stock
      c.stock_disp:= new_stock; //Actualizo el stock
      
      //Actualizo el archivo
      seek(a, filePos(a) - 1); //Me muevo al telefono correspondiente
      write(a, c); //Actualizo el archivo con el nnuevo stock
      
      writeln(' ');
      writeln('Stock del celular ', nomCel, ' actualizado exitosamente!');
    end; 
  end;
  
  if not encontre then writeln('No se encontro el celular ingresado.');
  
  close(a); //Cierro el archivo
end;

//EXPORTAR CELULARES SIN STOCK A TXT.
procedure exportarTxtCelularesSinStock(var a:tArch);

    //ESCRIBIR CELULAR EN TXT
    procedure escribirCel(var at:Text; c:celular);
    begin
      writeln(at, c.marca);
      writeln(at, c.nombre);
      writeln(at, c.codigo);
      writeln(at, c.precio:0:2);
      writeln(at, c.stock_disp);
      writeln(at, c.stock_min);
      writeln(at, c.desc);
      writeln(at);
    end;
var
  at:Text; //Archivo de texto
  c:celular;
  encontre:boolean;
begin
  reset(a); //Abro archiivo binario.
  assign(at, 'SinStock.txt');
  rewrite(at); //Creo txt, si existe se sobreescribe.
  
  encontre:= false;
  
  while not EOF(a) do begin
    read(a, c); //Leo un celular
    
    if(c.stock_disp = 0) then begin
      escribirCel(at, c); //Escribo el celular en el archivo txt.
      encontre:= true;
    end;
  end;
  
  if encontre then
    writeln('Celulares sin stock Exportados exitosamente en el archivo "SinStock.txt". ')
  else
    writeln('No se encontraron celulares sin stock. ');
  
  //Cierro los archivos.
  close(a);
  close(at);
end;

//PROGRAMA PRINCIPAL  
var
  a:tArch;
  nom_arch: string;
  opcion:integer;
BEGIN
	writeln('Ingrese el Nombre del Archivo: ');
  readln(nom_arch);
  writeln(' ');
  
  assign(a, nom_arch); 
  
  mostrarMenu(); //Muestra el menu en pantalla.
  writeln('Ingrese una opcion: ');
  readln(opcion);
  
  while(opcion <> 8)do begin
    case opcion of
      1: cargarArchivo(a);
      2: listarCelularesStockMenorAMinimo(a);
      3: listarCelularesMatchDescripcion(a);
      4: exportarCelularesTxt(a);
      5: agregarCelular(a);
      6: modificarStock(a);
      7: exportarTxtCelularesSinStock(a)
    else
      writeln('Opcion Invalida. Intentelo nuevamente. ');
    end;
    
    mostrarMenu(); //Muestra el menu en pantalla.
    writeln('Ingrese una opcion: ');
    readln(opcion);
  end;
  
  writeln('Saliendo del Programa...');
END.

// NOTA: No cierro el archivo binario en el PP porque dentro de cada proceso, abro y cierro el archivo.

{
  5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
  De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
  stock mínimo y precio del producto.
  
  Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. 
   
  * Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
    maestro. La información que se recibe en los detalles es: código de producto y cantidad
    vendida. 
    
    Además, se deberá informar en un archivo de texto: nombre de producto,
    descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
    debajo del stock mínimo. 
  
  Pensar alternativas sobre realizar el informe en el mismo
  procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
  ventajas/desventajas en cada caso).
  
  Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
  puede venir 0 o N registros de un determinado producto.
}


program Ejercicio5;
uses SysUtils;

const
    N = 30;
    valorAlto = 9999;

type
  producto = record
    codigo:integer;
    nombre:String;
    descripcion:String;
    stock_disp:integer;
    stock_min:integer;
    precio:real;
  end;

  venta = record
    codigo:integer;
    cantVendida:integer;
  end;
  
  tMaestro = file of producto;
  tDetalle = file of venta;
  
  vSucursales = array [1..N] of tDetalle; //Para abrir leer y cerrar los archivos detalles.
  vRegsSucursales = array [1..N] of venta; //Para guardarme los datos del registro actual de cada archivo detalle.

//PROCESOS  

//ASIGNAR ARCHIVOS DETALLES
procedure asignarArchivosDetalles(var v:vSucursales);
var
  i:integer;
begin
  for i:= 1 to N do 
    assign(v[i], 'detalle_' + IntToStr(i) + '.dat'); //IntToStr(i), convierto el valor de i en un string.
end;

//LEER
procedure leer(var d:tDetalle; var regD:venta);
begin
  if not EOF (d) then
    read(d, regD) //Leo una venta.
  else
    regD.codigo:= valorAlto;
end;

//ABRIR ARCHIVOS DETALLES
procedure abrirArchivosDetalles(var v:vSucursales; var r:vRegsSucursales);
var
  i:integer;
begin
  for i:= 1 to N do begin
    reset(v[i]); //Abro el archivo en la posicion i.
    leer(v[i], r[i]); //Leo un registro del detalle en la posicion i y lo guardo en el registro en la posicion i del arreglo de registros.
  end;
end;

//CERRAR ARCHIVOS DETALLLES
procedure cerrarArchivosDetalles(var v:vSucursales);
var
  i:integer;
begin
  for i:= 1 to N do 
    close(v[i]);
  end;
  
//MINIMO
procedure minimo(var v:vSucursales; var registros:vRegsSucursales; var min:venta);
var
  i, posmin:integer;
begin
  min.codigo:= valorAlto;
  
  for i:= 1 to N do begin
    if(registros[i].codigo < min.codigo)then begin
      min:= registros[i];
      posmin:= i;
    end;
  end;
  
  if(min.codigo <> valorAlto)then 
    leer(v[posmin], registros[posmin]);
end;

//ACTUALIZAR MAESTRO
procedure actualizarMaestro(var m:tMaestro; var v:vSucursales);
var
  registros: vRegsSucursales;
  regM:producto;
  min:venta;
  totalVendido:integer;
  codActual:integer;
begin
  abrirArchivosDetalles(v, registros); //Abro los archivos detalles para trabajar con ellos. Y leo el primer registro de cada uno de ellos.
  reset(m); //Abro el archivo maestro.
  
  minimo(v,registros, min); //Me quedo con el registro minimo, entre todos los detalles.
  while(min.codigo <> valorAlto)do begin
    totalVendido:= 0;
    codActual:= min.codigo;
    //Acumulamos las ventas del mismo producto.
    while (min.codigo <> valorAlto) and (min.codigo = codActual) do begin
      totalVendido:= totalVendido - min.cantVendida;
      minimo(v, registros, min); 
    end;
    
    //Busco el registro en el archivo maestro.
    read(m, regM); 
    while(regM.codigo <> codActual) do 
      read(m, regM);
      
    //Actualizo y guardo en el maestro.
    regM.stock_disp:= regM.stock_disp + totalVendido;
    seek(m, filePos(m) - 1); //Reubico el puntero en el producto correcto.
    write(m, regM);
  end;
  
  //Cierro los archivos.
  close(m);
  cerrarArchivosDetalles(v);
end;


//GENERAR INFORME
procedure generarInforme(var m:tMaestro);
var
  regM:producto;
  t:Text;
begin
  assign(t, 'Informe.txt');
  rewrite(t); //Creo el archivo .txt
  reset(m); //Abro el archivo maestro.
  
  writeln(t, '==== PRODUCTOS CON STOCK BAJO ====');
  writeln(t);
  while not EOF(m) do begin
    read(m, regM); //Leo un registro del maestro.
    if(regM.stock_disp < regM.stock_min)then begin
      writeln(t, 'Nombre: ', regM.nombre);
      writeln(t, 'Descripcion: ', regM.descripcion);
      writeln(t, 'Stock Disponible: ', regM.stock_disp);
      writeln(t, 'Precio: ', regM.precio);
      writeln(t);
    end;
  end;
  
  //Cierro los archivos
  close(m);
  close(t);
end;
  
//PROGRAMA PRINCIPAL  
var
  m:tMaestro;
  v:vSucursales;
BEGIN
  assign(m, 'Maestro.dat');
  asignarArchivosDetalles(v); //Asigno las variables logicas con los archivos detalles fisicos.
  actualizarMaestro(m, v); //Actualizo el maestro con los datos de los detalles.
  generarInforme(m); //Genero e informe en el archivo de texto.
END.


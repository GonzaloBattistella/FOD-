{
  3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
  de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
  productos que comercializa. De cada producto se maneja la siguiente información: código de
  producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
  genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
  cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
  realizar un programa con opciones para:
 
  a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
    ● Ambos archivos están ordenados por código de producto.
    ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
      archivo detalle.
    ● El archivo detalle sólo contiene registros que están en el archivo maestro.
 
  b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
  stock actual esté por debajo del stock mínimo permitido.
}

program Ejercicio3;
const
  valorAlto = 9999;
type
  producto = record
    codigo:integer;
    precio:real;
    stock_act:integer;
    stock_min:integer;
    nombre:String;
  end;
  
  venta = record
    codigo:integer;
    cantUnidades:integer;
  end;
  
  tDetalle = file of venta;
  tMaestro = file of producto;

//PROCESOS

//IMPRIMIR DETALLE
procedure imprimirDetalle(var det:tDetalle);
var
  v:venta;
begin
  reset(det); //Abro el archivo detalle
  
  writeln(' ');
  writeln('--------------------------------------');
  writeln('ARCHIVO DETALLE');
  writeln('--------------------------------------');
  while not EOF(det) do begin
    read(det, v); //Leo una venta;
    writeln('Codigo de Venta: ', v.codigo);
    writeln('Cantidad de Unidades Vendidas: ', v.cantUnidades);
    writeln('--------------------------------------');
  end;
  
  writeln(' ');
  
  close(det); //Cierro el Archivo
end;

//IMPRIMIR MAESTRO
procedure imprimirMaestro(var m:tMaestro);
var
  p:producto;
begin
  reset(m); //Abro el archivo maestro.
  
  writeln(' ');
  writeln('--------------------------------------');
  writeln('ARCHIVO MAESTRO');
  writeln('--------------------------------------');
  
  while not EOF(m) do begin
    read(m, p); //Leo un Producto.
    writeln('Codigo: ', p.codigo);
    writeln('Nombre: ', p.nombre);
    writeln('Precio: ', p.precio:0:2);
    writeln('Stock Actual: ', p.stock_act);
    writeln('Stock Minimo: ', p.stock_min);
    writeln('--------------------------------------');
  end;
  
  writeln(' ');
  
  close(m); //Cierro el detalle.
end;

//LEER DETALLE
procedure leerDetalle(var det:tDetalle; var regD:venta);
begin
  if not EOF(det) then 
    read(det, regD)
  else
    regD.codigo:= valorAlto;
end;

//ACTUALIZAR MAESTRO
procedure actualizarMaestro(var m:tMaestro; var det:tDetalle);
var
  regM:producto;
  regD:venta;
begin
  //Abro los Archivos.
  reset(m);
  reset(det);
  
  leerDetalle(det, regD);
  while(regD.codigo <> valorAlto) do begin
    read(m, regM);
    
    while(regM.codigo <> regD.codigo) do 
      read(m, regM); //Leo hasta encontrar el producto del detalle.

    while(regM.codigo = regD.codigo) do begin
      regM.stock_act:= regM.stock_act - regD.cantUnidades;
      
      leerDetalle(det, regD); //Mientras sea el mismo codigo, sigo leyendo del archivo detalle.
    end;
    
    seek(m, filePos(m) - 1); //Reubico el puntero en el registro correspondiente.
    write(m, regM); //Escribo en el archivo maestro.
  end;
  
  //Cierro los archivos
  close(m);
  close(det);
  
  writeln('Archivo "productos.dat" actualizado Exitosamente!. ');
end;


//PROGRAMA PRINCIPAL
var
  det:tDetalle;
  m:tMaestro;
BEGIN
  assign(det, 'ventas.dat');
  assign(m, 'productos.dat');
  
  imprimirDetalle(det);
  imprimirMaestro(m);
  ActualizarMaestro(m, det);
  imprimirMaestro(m);
END.

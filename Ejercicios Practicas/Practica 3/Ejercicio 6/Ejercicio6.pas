{
  Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con 
  la información correspondiente a las prendas que se encuentran a la venta. 
  
  De cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y 
  precio_unitario. 
  
  Ante un eventual cambio de temporada, se deben actualizar las 
  prendas a la venta. 
  
  Para ello reciben un archivo conteniendo: cod_prenda de las 
  prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba 
  ambos archivos y  realice la baja lógica de las prendas, para ello deberá modificar el 
  stock de la prenda correspondiente a valor negativo. 
  
  Adicionalmente, deberá implementar otro procedimiento que se encargue de 
  efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la 
  información de las prendas a la venta. 
  
  Para ello se deberá utilizar una estructura auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente 
  aquellas prendas que no están marcadas como borradas. 
  
  Al finalizar este proceso de compactación del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro original.
}


program Ejercicio6;
type
  prenda = record
    cod_prenda:integer;
    descripcion:string;
    colores:String;
    tipo_prenda:String;
    stock:integer;
    precio_unitario:real;
  end;
  
  tArch = file of prenda;
  tDet = file of Integer;
  
//PROCESOS

//ELIMINAR PRENDA
procedure eliminarPrenda(var a:tArch; cod:integer);
var
  p:prenda;
  encontre:boolean;
begin
  reset(a); //Abro el Archivo Maestro.
  
  encontre:= false;
  
  while not EOF(a) and not encontre do begin
    read(a, p);
    
    if(p.cod_prenda = cod)then begin
      encontre:= true;
      p.stock:= p.stock * -1; //convierto el valor a negativo.
      
      //Actualizo el maestro con el nuevo valor.
      seek(a, filePos(a) - 1);
      write(a, p);
      writeln('Prenda Eliminada Exitosamente!.');
    end;
  end;
  
  if not encontre then writeln('No se encontro la prenda!.');
  
  close(a); //Cierro el Archivo.
end;

//REALIZAR BAJA LOGICA
procedure realizarBajasLogicas(var a:tArch; var d:tDet);
var
  cod:integer;
begin
  reset(d); //Abro el Archivo.
  
  while not EOF (d) do begin
    read(d, cod); //Leo un codigo a borrar.
    eliminarPrenda(a, cod);
  end;
  
  writeln('Se realizaron las Bajas Logicas con Exito!.');
  
  close(d);
end;

//EFECTUAR BAJAS
procedure efectuarBajas(var a:tArch);
var
  maestronuevo:tArch;
  p:prenda;
begin
  assign(maestronuevo, 'prendas_temp.dat');
  rewrite(maestronuevo); //Creo el archivo, si existe se sobreescribe.
  reset(a);
  
  while not EOF (a) do begin
    read(a, p); //Leo una prenda.
    if(p.stock > 0) then write(maestronuevo, p);
  end;
  
  //Cierro los archivos
  close(a);
  close(maestronuevo);
  
  //Reemplazo los nombres de llos archivos.
  erase(a); //Elimino el archivo maestro original.
  rename(maestronuevo, 'Prendas.dat'); //Renombro el nuevo maestro.
end;

//PROGRAMA PRINCIPAL
var
  a:tArch; //Archivo Maestro.
  d:tDet;
BEGIN
  assign(a, 'Prendas.dat');
  assign(d, 'Detalle.dat');
  
	realizarBajasLogicas(a, d);
  efectuarBajas(a);
END.


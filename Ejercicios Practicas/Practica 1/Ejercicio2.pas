{
  2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
  creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
  promedio de los números ingresados. El nombre del archivo a procesar debe ser
  proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
  contenido del archivo en pantalla.
}


program Ejercicio2;
const
  max = 1500;
type
  tArch = File of Integer;
  
//PROCESOS.

//CANT NUMEROS MENORES.
function cantNumerosMenores(var a:tArch):integer;
var
  cant:integer;
  num:integer;
begin
  cant:= 0;
  
  while not EOF(a) do begin
    read(a, num); //Leo un numero del archivo.
    if(num < max) then
      cant:= cant + 1;
  end;
  
  cantNumerosMenores:= cant;
end;

//LISTAR ARCHIVO.
procedure listarContenido(var a:tArch);
var
  num:integer;
begin
  reset(a); //Posiciono el puntero al inicio del archivo.
  
  writeln(' ');
  writeln('---------------------------------------');
  writeln('NUMEROS ARCHIVO');
  writeln('---------------------------------------');
  
  while not EOF(a) do begin
    read(a, num); //Leo un numero del archivo.
    writeln('NUMERO: ', num);
    writeln('---------------------------------------');
  end;
  writeln(' ');
end;


//PROGRAMA PRINCIPAL.
var
  a:tArch;
  nomArch: String;
BEGIN
  writeln('Ingrese el nombre del archivo con extension de ser necesario: ');
  readln(nomArch);
  writeln(' ');
  
  assign(a, nomArch);
  reset(a); //Abro el archivo.
  
  writeln('La cantidad de numeros menores a ', max, ' es: ', cantNumerosMenores(a)); //Informo la canntidad de numeros menores a max, que en este caso es 1500.
  listarContenido(a); //Muestro el contenido del archivo en pantalla.
  
  close(a); //Cierro el archivo.
END.


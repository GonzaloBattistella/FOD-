{
  Dada la siguiente estructura:  

  type 
    reg_flor = record 
      nombre: String[45]; 
      codigo: integer; 
    end; 
  
    tArchFlores = file of reg_flor; 

  Las bajas se realizan apilando registros borrados y las altas reutilizando registros 
  borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el 
  número 0 en el campo código implica que no hay registros borrados y -N indica que el 
  próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.  

  a. Implemente el siguiente módulo: 
  Abre el archivo y agrega una flor, recibida como parámetro 
  manteniendo la política descrita anteriormente

  procedure agregarFlor (var a: tArchFlores ; nombre: string; 
  codigo:integer); 

  b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que 
  considere necesario para obtener el listado. 
}


program Ejercicio4;
type
  reg_flor = record
    nombre:String[45];
    codigo:integer;
  end;
  
  tArch = file of reg_flor;

//PROCESOS
procedure mostrarMenu();
begin
  writeln(' ');
  writeln('------------------------------------------');
  writeln('MENU DE OPCIONES');
  writeln('------------------------------------------');
  writeln('1. Crear Archivo.');
  writeln('2. Eliminar Flor.');
  writeln('3. Agregar Flor.');
  writeln('4. Imprimir Archivo.');
  writeln('5. Salir.');
  writeln('------------------------------------------');
  writeln(' ');
end;

//LEER FLOR
procedure leerFlor(var r:reg_flor);
begin
  writeln(' ');
  writeln('Ingrese el Nombre de la Flor: ');
  readln(r.nombre);
  
  if(r.nombre <> '.')then begin
    writeln('Ingrese el Codigo de la Flor: ');
    readln(r.codigo);
  end;
  
  writeln('------------------------------------------');
end;


//CREAR ARCHIVO
procedure crearArchivo(var a:tArch);
var
  r:reg_flor;
begin
  rewrite(a); //Creo el archivo, si existe se sobreescribe.
  
  //Creo el registro cabecera.
  r.nombre:= 'Cabecera Archivo.';
  r.codigo:= 0;
  seek(a, 0); //Me posiciono en el registro 0.
  write(a, r);
  
  //Cargo la informacion ingresada por teclado.
  leerFlor(r);
  while(r.nombre <> '.')do begin
    write(a, r);
    leerFlor(r);
  end;

  writeln('Archivo creado con Exito!.');
  
  close(a);
end;

//ELIMINAR FLOR
procedure eliminarFlor(var a:tArch);
var
  reg, cabecera:reg_flor;
  pos, codigo:integer;
  encontre:boolean;
begin
  reset(a); //Abro el Archivo.
  
  writeln(' ');
  writeln('Ingrese el Codigo de Flor a Borrar: ');
  readln(codigo);
  
  encontre:= false;
  
  //Busco la novela a borrar.
  while not EOF(a) and not encontre do begin
    read(a, reg); //Leo una flor
    
    if(reg.codigo =  codigo) then begin
      encontre:= true;
      pos:= filePos(a) - 1; //Me quedo con la posicion del registro a borrar.
    end;
  end;
  
  if encontre then begin
    
    //Me quedo con el registro cabecera
    seek(a, 0);
    read(a, cabecera);
    
    //Me posiciono en el registro a borrar.
    seek(a, pos);
    write(a, cabecera);
    
    //Actualizo la cabecera con la proxima posicion a reutilizar.
    cabecera.codigo:= -pos;
    seek(a, 0);
    write(a, cabecera);
    
    writeln('Flor Eliminada Exitosamente!');
  end else writeln('El Codigo de Flor ingresado no se ha encontrado.');
  
  close(a); //Cierro el Archivo.
end;

//DAR DE ALTA FLOR
procedure darDeAltaFlor(var a:tArch);
var
  reg, regLibre:reg_flor;
  posLibre:integer;
begin
  reset(a); //Abro el Archivo.
  
  leerFlor(reg); //Leo la Flor a agregar en el archivo.
  while(reg.nombre <> '.')do begin 
    
    //Leo el registro cabecera.
    seek(a, 0); //Me aseguro de posicionarme en el registro cabecera.
    read(a, regLibre);
    
    if (regLibre.codigo = 0) then begin
      //No hay lugar libre, agrego al final del archivo.
      seek(a, fileSize(a));
      write(a, reg);
    end
    else begin
      //Hay espacio libre en la poscion regLibre.codigo.
      posLibre:= abs(regLibre.codigo); //ABS(): Me quedo con el valor absoluto, es decir con el numero positivo.
      seek(a, posLibre);
      read(a, regLibre); //Ahora regLibre.codigo tiene el proximo lugar libre.
      
      //Escribo la nueva flor en la posicion libre.
      seek(a, posLibre);
      write(a, reg);
      
      //Actualizo la cabecera con la nueva posicion libre.
      seek(a, 0);
      write(a, regLibre);
    end;
    
    writeln('Se agrego la Flor Exitosamente!.');
    writeln(' ');
    leerFlor(reg);
  end;
  
  close(a); //Cierro el Archivo.
end;

//IMPRIMIR ARCHIVO
procedure imprimirArchivo(var a:tArch);
var
  reg:reg_flor;
begin
  reset(a); //Abro el Archivo.
  
  writeln(' ');
  writeln('---------------------------------------');
  writeln('FLORES');
  writeln('---------------------------------------');
  
  while not EOF (a) do begin
    read(a, reg); //Leo una flor
    
    if(reg.codigo > 0) then begin 
      writeln('NOMBRE: ', reg.nombre);
      writeln('CODIGO: ', reg.codigo);
      writeln('---------------------------------------');
    end;
  end;
  
  close(a); //Cierro el Archivo.
end;

//PROGRAMA PRINCIPAL
var
  a:tArch;
  opcion:integer;
BEGIN
  assign(a, 'Flores.dat');
  
  mostrarMenu();
  writeln(' ');
  writeln('Ingrese una Opcion: ');
  readln(opcion);
  
  while(opcion <> 5)do begin
    case opcion of
      1:crearArchivo(a);
      2:eliminarFlor(a);
      3:darDeAltaFlor(a);
      4:imprimirArchivo(a);
    else writeln('Opcion Invalida, Intentelo Nuevamente.');
    end;
    
    mostrarMenu(); //Vuelvo a mostrar el menu hasta que se ingrese la opcion para salir del programa.
    writeln(' ');
    writeln('Ingrese una Opcion: ');
    readln(opcion);
  end;
  
  writeln('Saliendo del Programa...');
END.


{
  3. Realizar un programa que presente un menú con opciones para:
  
  a. Crear un archivo de registros no ordenados de empleados y completarlo con
  datos ingresados desde teclado. De cada empleado se registra: número de
  empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
  DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

  b. Abrir el archivo anteriormente generado y
    i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
    determinado, el cual se proporciona desde el teclado.

    ii. Listar en pantalla los empleados de a uno por línea.
    
    iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

  NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}


program Ejercicio3;
type
  empleado = record
    numero:integer;
    apellido:string;
    nombre:string;
    edad:integer;
    dni:integer;
  end;
  
  tArch = File of empleado;

//PROCESOS

//MOSTRAR MENU DE OPCIONES.
procedure mostrarMenu();
begin
  writeln(' ');
  writeln('---------------------------------------');
  writeln('MENU DE OPCIONES');
  writeln('---------------------------------------');
  writeln('1. Cargar Archivo con Empleados.');
  writeln('2. Mostrar Empleado con Nombre o Apellido determiado.');
  writeln('3. Mostrar Listado de Empleados.');
  writeln('4. Mostrar Empleados Proximos a Jubilarse.');
  writeln('5. Salir.');
  writeln('---------------------------------------');
  writeln(' ');
end;


//CARGAR ARCHIVO EMPLEADOS.
procedure cargarArchivoEmpleados(var a:tArch);

    //LEER EMPLEADO.
    procedure leerEmpleado(var emp:empleado);
    begin
      writeln(' ');
      writeln('Ingrese el apellido: ');
      readln(emp.apellido);
      if(emp.apellido <> 'fin')then begin
        writeln('Ingrese el nombre del empleado: ');
        readln(emp.nombre);
        writeln('Ingrese la edad del Empleado: ');
        readln(emp.edad);
        writeln('Ingrese el numero de Empleado: ');
        readln(emp.numero);
        writeln('Ingrese el DNI del Empleado: ');
        readln(emp.dni);
        writeln('---------------------------------------');
      end;
    end;

var
  emp:empleado;
begin
  
  leerEmpleado(emp);
  while(emp.apellido <> 'fin')do begin
    write(a, emp);
    leerEmpleado(emp);
  end;
end;

//MOSTRAR EMPLEADO.
procedure mostrarEmpleado(e:empleado);
begin
  writeln(' ');
  writeln('---------------------------------------');
  writeln('Nombre del Empleado: ', e.nombre);
  writeln('Apellido del Empleado: ', e.apellido);
  writeln('Edad del Empleado: ', e.edad);
  writeln('Numero de Empleado: ', e.numero);
  writeln('DNI del Empleado: ', e.dni);
  writeln('---------------------------------------');
end;

//MOSTRAR DETERMINADOS EMPLEADOS
procedure mostrarDeterminadosEmpleados(var a:tArch);
var
  cadena: String;
  e: empleado;
begin
  writeln(' ');
  writeln('Ingrese un nombre o apellido a buscar: ');
  readln(cadena);
  
  reset(a); //Ubico el puntero en el inicio del archivo.
  
  while not EOF(a) do begin
    read(a, e); //Leo un empleado del archivo y lo guardo en e.
    if(e.nombre = cadena) or (e.apellido = cadena)then
      mostrarEmpleado(e);
  end;
end;

//LISTAR EMPLEADOS.
procedure listarEmpleados(var a: tArch);
var
  e:empleado;
begin
  reset(a);
  
  writeln(' ');
  writeln('-------------------------------------');
  writeln('EMPLEADOS');
  writeln('-------------------------------------');
  
  while not EOF(a) do begin
    read(a, e); //Leo un empleado del archivo.
    mostrarEmpleado(e);
  end;
end;

//EMPLEADOS PROXIMOS A JUBILARSE.
procedure empleadosProximosAJubilarse(var a: tArch);
var
  e:empleado;
begin
  reset(a);
  
  writeln(' ');
  writeln('-------------------------------------');
  writeln('EMPLEADOS PROXIMOS A JUBILARSE');
  writeln('-------------------------------------');
  
  while not EOF(a) do begin
    read(a, e);
    if(e.edad > 70)then
      mostrarEmpleado(e);
  end;
end;

//PROGRAMA PRINCIPAL.  
var
  a: tArch;
  nomArch:string;
  opcion:integer;
BEGIN
  writeln('Ingrese el nombre del archivo: ');
  readln(nomArch); //Nombre del archivo fisico.
  
  assign(a, nomArch);
  rewrite(a); //Creo el archivo.
  
  mostrarMenu();
  writeln('Ingrese una opcion: ');
  readln(opcion);
  
  while (opcion <> 5)do begin
    case opcion of
      1: cargarArchivoEmpleados(a);
      2: mostrarDeterminadosEmpleados(a);
      3: listarEmpleados(a);
      4: empleadosProximosAJubilarse(a)
    else
      writeln('Opcion Invalida. Intente Nuevamente. ');
    end;
    
    //Vuelvo a mostrar el mennu de opciones.
    mostrarMenu();
    writeln('Ingrese una opcion: ');
    readln(opcion);
  end;
  
  close(a); //Cierro el Archivo.
  writeln('Saliendo del programa...');
END.


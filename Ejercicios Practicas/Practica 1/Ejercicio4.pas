{
  4. Agregar al menú del programa del ejercicio 3, opciones para:
  
  a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
  teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
  un número de empleado ya registrado (control de unicidad).

  b. Modificar la edad de un empleado dado.

  c. Exportar el contenido del archivo a un archivo de texto llamado
  “todos_empleados.txt”.

  d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
  que no tengan cargado el DNI (DNI en 00).
  
  NOTA: Las búsquedas deben realizarse por número de empleado.
}


program Ejercicio4;
type
  empleado = record
    numero:integer;
    apellido:string;
    nombre:string;
    edad:integer;
    dni:integer;
  end;
  
  tArch = File of empleado;
  
  tText = TextFile;

//PROCESOS

//MOSTRAR MENU DE OPCIONES.
procedure mostrarMenu();
begin
  writeln(' ');
  writeln('---------------------------------------');
  writeln('MENU DE OPCIONES');
  writeln('---------------------------------------');
  writeln('1. Cargar Archivo con Empleados.');
  writeln('2. Mostrar Empleado con Nombre o Apellido determinado.');
  writeln('3. Mostrar Listado de Empleados.');
  writeln('4. Mostrar Empleados Proximos a Jubilarse.');
  writeln('5. Agregar Empleado.');
  writeln('6. Modificar Edad Empleado.');
  writeln('7. Exportar Empleados a .txt.');
  writeln('8. Exportar Empleados sin DNI.');
  writeln('9. Salir.');
  writeln('---------------------------------------');
  writeln(' ');
end;


//LEER EMPLEADO.
procedure leerEmpleado(var emp:empleado);
begin
  writeln(' ');
  writeln('Ingrese el apellido del Empleado: ');
  readln(emp.apellido);
  if(emp.apellido <> 'fin')then begin
    writeln('Ingrese el nombre del Empleado: ');
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

//CARGAR ARCHIVO EMPLEADOS.
procedure cargarArchivoEmpleados(var a:tArch);
var
  emp:empleado;
begin
  
  leerEmpleado(emp);
  while(emp.apellido <> 'fin')do begin
    write(a, emp);
    leerEmpleado(emp);
  end;
  
  close(a);
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
  
  close(a);
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
  
  close(a);
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
  
  close(a);
end;

//AGREGAR EMPLEADO.
procedure agregarEmpleado(var a:tArch);

    //FUNCION: EXISTE EMPLEADO.
    function existeEmpleado(var a:tArch; e:empleado):boolean;
    var
      existe:boolean;
      aux:empleado;
    begin
      existe:= false;
      
      // Verifico si el número de empleado ya existe
      while not EOF(a) and not existe do begin
        read(a, aux);
        if (aux.numero = e.numero) then
          existe:= true;
      end;
      
      existeEmpleado:= existe; //Retorno el valor de la variable existe.
    end;

var
  e:empleado;
begin
  reset(a); //Seteo el puntero al inicio del archivo.
  
  leerEmpleado(e);
  while (e.apellido <> 'fin') do begin
    if not existeEmpleado(a, e) then begin
      seek(a, filesize(a)); //Posiciono el puntero al final del archivo.
      write(a, e); //Escribo el nuevo empleado al final del archivo.
      writeln('Empleado agregado correctamente.');
    end
    else
      writeln('Error: El número de empleado ya existe.');
    
    leerEmpleado(e);
  end;

  close(a);
end;



//MODIFICAR EDAD EMPLEADO.
procedure modificarEdadEmpleado(var a:tArch);
var
  e:empleado;
  num_empleado:integer;
  edad_nueva:integer;
  encontre:boolean;
begin
  encontre:= false;
  reset(a);
  
  writeln(' ');
  writeln('Ingrese el numero de Empleado a Modificar: ');
  readln(num_empleado);
  writeln(' ');
  
  //Busco si se encuentra el empleado en el archivo.
  while not EOF(a) and (not encontre) do begin
    read(a, e);
    if(e.numero = num_empleado)then begin
      encontre:= true;
      writeln('Ingrese la nueva edad del Empleado: ');
      readln(edad_nueva);
      e.edad:= edad_nueva; //Modifico la edad de empleado.
      seek(a, filePos(a) - 1); //Me posiciono en el empleado encontrado nuevamente. DATO: Cuando se hace un read() en un archivo, esta fucion me devuelve el dato y se posiciona en la siguiente posicion.
      write(a, e);
      writeln(' ');
      writeln('Edad del empleado ', num_empleado, ' modificada exitosamente.');
    end;
  end;
  
  if(not encontre)then writeln('Empleado no encontrado.');
  
  close(a);
end;

//EXPORTAR CONTENIDO TXT.
procedure exportarContenidoTxt(var a:tArch);
var
  e:empleado;
  at: tText; //Archivo de texto.
begin
  assign(at, 'todos_empleados.txt');
  rewrite(at); //Se sobreescribe si el archivo existe.
  
  reset(a); //Abro el archivo binario. 
  
  while not EOF(a) do begin
    read(a, e); //Leo un empleado del archivo binario.
    
    //Escribo en el archivo de texto.
    writeln(at, 'Numero de Empleado: ', e.numero);
    writeln(at, 'Nombre: ', e.nombre);
    writeln(at, 'Apellido: ', e.apellido);
    writeln(at, 'Edad: ', e.edad);
    writeln(at, 'DNI: ', e.dni);
    writeln(at); //Linea en blanco para separar cada empleado.
  end;
  
  //Cerrar los archivos.
  close(a);
  close(at);
  
  writeln(' ');
  writeln('Todos los empleados han sido exportados correctamente a "todos_empleados.txt".');
end;

//EXPORTAR EMPLEADOS SIN DNI.
procedure exportarEmpleadosSinDni(var a:tArch);
var
  e:empleado;
  arch_txt: tText; //Archivo de texto
begin
  assign(arch_txt, 'faltaDNIEmpleado.txt');
  rewrite(arch_txt); //Se sobreescribe si el archivo existe.
  
  reset(a); //Abro el archivo binario.
  
  while not EOF(a) do begin
    read(a, e); //Leo un empleado
    
    if(e.dni = 00)then begin
      //Escribo en el archivo de texto.
      writeln(arch_txt, 'Numero de Empleado: ', e.numero);
      writeln(arch_txt, 'Nombre: ', e.nombre);
      writeln(arch_txt, 'Apellido: ', e.apellido);
      writeln(arch_txt, 'Edad: ', e.edad);
      writeln(arch_txt, 'DNI: ', e.dni);
      writeln(arch_txt); //Linea en blanco para separar cada empleado.
    end;
  end;
  
  //Cierro los archivos.
  close(a);
  close(arch_txt);
  
  writeln(' ');
  writeln('Se han exportado exitosamente todos los empleados sin dni a "faltaDNIEmpleado.txt".');
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
  
  while (opcion <> 9)do begin
    case opcion of
      1: cargarArchivoEmpleados(a);
      2: mostrarDeterminadosEmpleados(a);
      3: listarEmpleados(a);
      4: empleadosProximosAJubilarse(a);
      5: agregarEmpleado(a);
      6: modificarEdadEmpleado(a);
      7: exportarContenidoTxt(a);
      8: exportarEmpleadosSinDni(a);
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


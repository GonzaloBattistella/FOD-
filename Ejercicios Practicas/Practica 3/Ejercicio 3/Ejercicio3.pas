{
  3. Realizar un programa que genere un archivo de novelas filmadas durante el presente 
  año. De cada novela se registra: código, género, nombre, duración, director  y precio. 
  
  El programa debe presentar un menú con las siguientes opciones: 
    
    a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se 
    utiliza la técnica de lista invertida para recuperar espacio libre en el 
    archivo.  Para ello, durante la creación del archivo, en el primer registro del 
    mismo se debe almacenar la cabecera de la lista. Es decir un registro 
    ficticio, inicializando con el valor cero (0) el campo correspondiente al 
    código de novela, el cual indica que no hay espacio libre dentro del 
    archivo. 

    b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el 
    inciso a), se utiliza lista invertida para recuperación de espacio. En 
    particular, para el campo de “enlace”  de la lista (utilice el código de 
    novela como enlace), se debe especificar los números de registro 
    referenciados con signo negativo, . Una vez abierto el archivo, brindar 
    operaciones para: 

      i. Dar de alta una novela leyendo la información desde teclado. Para 
      esta operación, en caso de ser posible, deberá recuperarse el 
      espacio libre. Es decir, si en el campo correspondiente al código de 
      novela del registro cabecera hay un valor negativo, por ejemplo -5, 
      se debe leer el registro en la posición 5, copiarlo en la posición 0 
      (actualizar la lista de espacio libre) y grabar el nuevo registro en la 
      posición 5. Con el valor 0 (cero) en el registro cabecera se indica 
      que no hay espacio libre.    

      ii. Modificar los datos de una novela leyendo la información desde 
      teclado. El  código de novela no puede ser modificado. 

      iii. Eliminar una novela cuyo código es ingresado por teclado. Por 
      ejemplo, si se da de baja un registro en la posición 8, en el campo 
      código de novela del registro cabecera deberá figurar -8, y en el 
      registro en la posición 8 debe copiarse el antiguo registro cabecera. 

    c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que 
    representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”. 

    NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser 
    proporcionado por el usuario.
}


program Ejercicio3;
type
  novela = record
    codigo:integer;
    genero:string;
    nombre:string;
    duracion:integer; //En minutos
    director:string;
    precio:real;
  end;
  
  tArch = file of novela;

//PROCESOS

//MOSTRAR MENU
procedure mostrarMenu();
begin
  writeln(' ');
  writeln('----------------------------------------------');
  writeln('MENU DE OPCIONES');
  writeln('----------------------------------------------');
  writeln('1. CREAR ARCHIVO');
  writeln('2. REALIZAR MANTENIMIENTO AL ARCHIVO');
  writeln('3. LISTAR NOVELAS EN ARCHIVO TXT');
  writeln('4. SALIR');
  writeln('----------------------------------------------');
  writeln(' ');
end;

//LEER NOVELA
procedure leerNovela(var n:novela);
begin
  writeln(' ');
  writeln('Ingrese el codigo de la novela (0 para salir): ');
  readln(n.codigo);
  
  if(n.codigo <> 0)then begin
    writeln('Ingrese el genero de la novela: ');
    readln(n.genero);
    writeln('Ingrese el nombre de la novela: ');
    readln(n.nombre);
    writeln('Ingrese la duracion de la novela: ');
    readln(n.duracion);
    writeln('Ingrese el director de la novela: ');
    readln(n.director);
    writeln('Ingrese el precio de la novela: ');
    readln(n.precio);
  end;
  
  writeln('----------------------------------------------');
end;

//CREAR ARCHIVO 
procedure crearArchivo(var a:tArch);
var
  n:novela;
  nomArch:string;
begin
  writeln('Ingrese el nombre del archivo: ');
  readln(nomArch); 
  assign(a, nomArch);
  rewrite(a); //Creo el archivo, si existe se sobreescribe.
  
  //Creo el registro ficticio en la posicion 0.
  n.codigo:= 0; //0 significa que no hay espacio libre.
  write(a, n); //Escribo el registro ficticio en el archivo.
  
  //Cargo el archivo con la informacion de las novelas.
  leerNovela(n); 
  while(n.codigo <> 0)do begin
    write(a, n); //Escribo la novela leida desde teclado en el archivo
    leerNovela(n);
  end;
  
  writeln('Archivo cargado Exitosamente!');
  
  close(a); //Cierro el Archivo.
end;

//MANTENIMIENTO ARCHIVO
procedure mantenimientoArchivo(var a:tArch);
  
  //MOSTRAR MENU MANTENIMIENTO
  procedure mostrarMenuMantenimiento();
  begin
    writeln(' ');
    writeln('----------------------------------------');
    writeln('MENU MANTENIMIENTO');
    writeln('----------------------------------------');
    writeln('1. DAR DE ALTA NOVELA');
    writeln('2. MODIFICAR NOVELA');
    writeln('3. ELIMINAR NOVELA');
    writeln('4. SALIR');
    writeln('----------------------------------------');
    writeln(' ');
  end;
  
  //DAR ALTA NOVELA
  procedure darAltaNovela(var a:tArch);
  var
    n, regLibre:novela;
    posLibre: integer;
    nomArch:String;
  begin
    writeln(' ');
    writeln('Ingrese el nombre del Archivo: ');
    readln(nomArch); 
    assign(a, nomArch);
    reset(a); //Abro el archivo.
    
    leerNovela(n);
    while(n.codigo <> 0)do begin
      
      //Leo el primer registro.
      seek(a, 0); //Me aseguro de posicionarme en el primer registro.
      read(a, regLibre); 
      
      if(regLibre.codigo = 0)then begin
        //No hay espacio libre, agrego al final.
        seek(a, fileSize(a));
        write(a, n);
      end
      else begin
        //Hay espacio libre en la posicion regLibre.codigo
        posLibre:= abs(regLibre.codigo);
        seek(a, posLibre);
        read(a, regLibre); //Ahora regLibre contiene el proximo libre.
        
        //Escribo la novela en la posicion libre
        seek(a, posLibre);
        write(a, n);
        
        //Actualizo la cabecera con la nueva posicion libre.
        seek(a, 0);
        write(a, regLibre);
      end;
      
      writeln('Novela Cargada con exito!');
      writeln(' '); 
      leerNovela(n);
    end;
    
    close(a); //Cierro el archivo.
  end;
  
  //MODIFICAR NOVELA
  procedure modificarNovela(var a:tArch);
  var
    n:novela;
    cod:integer;
    encontre:boolean;
    nomArch:String;
  begin
    encontre:= false;
    
    writeln(' ');
    writeln('Ingrese el nombre del Archivo: ');
    readln(nomArch); 
    assign(a, nomArch);
    reset(a); //Abro el archivo.
    
    writeln('Ingrese el codigo de la novela a buscar: ');
    readln(cod);
    
    //Busco la novela a modificar.
    while not EOF(a) and not encontre do begin
      read(a, n); //Leo una novela.
      
      
      //Si la encuentro moodifico los datos.
      if(n.codigo = cod)then begin
        encontre:= true;
        leerNovela(n); 
        seek(a, filePos(a) - 1); //Me posiciono el registro correcto.
        write(a, n); //Escribo los nuevos datos de la novela. 
      end;
    end;
    
    if not encontre then writeln('El codigo de Novela no Existe.')
    else writeln('Novela modificada correctamente!.');
    
    close(a); //Cierro el Archivo.
  end;
  
  
  //ELIMINAR NOVELA
  procedure eliminarNovela(var a:tArch);
  var
    n,cabecera:novela;
    codigo:integer;
    pos:integer; //Lo utlizo para quedarme con la posicion a borrar.
    encontre:boolean;
    nomArch:String;
  begin
    writeln(' ');
    writeln('Ingrese el nombre del Archivo: ');
    readln(nomArch); 
    assign(a, nomArch);
    reset(a); //Abro el archivo.
    
    writeln(' ');
    writeln('Ingrese el codigo de novela a Eliminar: ');
    readln(codigo);
    
    encontre:= false;
    
    //Busco la novela a borrar.
    while not EOF (a) and not encontre do begin
      read(a, n);
      if (n.codigo = codigo) then begin
        encontre:= true;
        pos:= filePos(a) - 1; //Me quedo con la posicion del registro.
      end;
    end;
    
    if encontre then begin
      
      //Me guardo el registro cebecera.
      seek(a, 0); 
      read(a, cabecera);
      
      //Copio el contenido de la cabecera en la posicion a borrar.
      seek(a, pos);
      write(a, cabecera);
      
      //Actualizo la cebecera
      cabecera.codigo:= -pos;
      seek(a, 0);
      write(a, cabecera);
      
      writeln('Novela Borrada Exitosamente!')
    end else writeln('No se encontro la novela ingresada.');
    
    //Cierro el archivo
    close(a); 
  end;
  
var
  opcion:integer;
begin
  mostrarMenuMantenimiento();
  writeln('Ingrese una opcion: ');
  readln(opcion); //Leo la opcion elegidad desde teclado.
  
  while(opcion <> 4)do begin
    case opcion of
      1: darAltaNovela(a); //Agrega una novela al final del archivo.
      2: modificarNovela(a); //Modifico los datos de una novela.
      3: eliminarNovela(a); //Elimino una novela logicamente, a traves del metodo de lista invertida.
    else writeln('Opcion Incorrecta, Intentelo nuevamente.');
    end;
    
    //Muestro el menu hasta que se ingrese la opcion para salir del programa.
    mostrarMenuMantenimiento();
    writeln('Ingrese una Opcion: '); 
    readln(opcion);
  end;
  
  writeln('Volviendo al Menu Principal...');
end;

//MOSTRAR NOVELAS TXT
procedure listarNovelasTxt(var a:tArch);
var
  estado:string;
  at: Text;
  n:novela;
  nomArch:String;
begin
  //Asignaciones y apertura de archivos.
  assign(at, 'Novelas.txt');
  writeln(' ');
  writeln('Ingrese el nombre del Archivo: ');
  readln(nomArch); 
  assign(a, nomArch);
  reset(a);
  rewrite(at); //Creo el archivo de texto, si existe se sobreescribe.
  
  seek(a, 1); //Empiezo desde la posicion 1, salteo la cabecera.
  
  while not EOF(a) do begin
    read(a, n); //Leo una novela
    
    //Determino si esta borrada logicamente
    if (n.codigo < 0) then 
      estado:= 'BORRADA'
    else
      estado:= 'ACTIVA';
      
    writeln(at, 'Estado: ', estado);
    writeln(at, 'Codigo: ', abs(n.codigo));
    writeln(at, 'Nombre: ', n.nombre);
    writeln(at, 'Genero: ', n.genero);
    writeln(at, 'Duracion: ', n.duracion, ' minutos');
    writeln(at, 'Director: ', n.director);
    writeln(at, 'Precio: ', n.precio:0:2);
    writeln(at); //Linea en blanco para separar entre las novelas.
  end;
  
  close(a); 
  close(at);
  writeln(' ');
  writeln('Archivo Exportado como "Novelas.txt" (Incluye Borradas) ');
  writeln(' ');
end;

//PROGRAMA PRINCIPAL
var
  a:tArch;
  opcion:integer;
BEGIN
  mostrarMenu();
  writeln('Ingrese una Opcion: '); 
  readln(opcion);
  
  while(opcion <> 4) do begin
    case opcion of
      1: crearArchivo(a); //Cargo el archivo, con el primer registro ficticio para manejar la lista invertida.
      2: mantenimientoArchivo(a); //Se realiza mantenimiento del archivo. Con un menu con opciones de mantenimiento.
      3: listarNovelasTxt(a); //Listo las novelas, incluidas las borradas, en un archivo llamado "novelas.txt".
    end;  
    
    //Muestro el menu hasta que se ingrese la opcion para salir del programa.
    mostrarMenu();
    writeln('Ingrese una Opcion: '); 
    readln(opcion);
  end;
  
  writeln('Saliendo del programa...');
END.

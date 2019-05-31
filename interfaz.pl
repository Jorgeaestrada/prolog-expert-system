% Declaracion de librerias utilizadas para 
% generar la interfaz grafica de todo el proyecto
:- use_module(library(pce)).
:- use_module(library(pce_style_item)).
:- pce_image_directory('./img').

:- dynamic excusa/5.

:- ensure_loaded('writeln.pl').
:- ensure_loaded('base_conocimiento.pl').
:- ensure_loaded('modulo_adquisicion.pl').

resource(img_principal,image,image('excusas.jpg')).

%
% Inicializa la interfaz principal:
% debes dar click en iniciar para empezar 
% a utilizar este programa
%
main:-
    new(Dialog,dialog('Sistema Experto: Excusas',size(500,800))),
    send(Dialog,colour,colour(blue)),
    send(Dialog,append,new(Menu,menu_bar)),
    new(Label,label(name,'PROYECTO UNIDAD 3&4 - PROLOG 7SA')),
    new(Label2,label(name,'Contesta las siguientes preguntas para hallar tu excusa')),
    new(Label3,label(name,'')),
    new(Exit,button('Salir',and(message(Dialog,destroy),
    	message(Dialog,free),
		message(Label,destroy),
		message(Label,free)))),
    new(Start,button('Iniciar',and(message(@prolog, cuestionario), 
    	message(Dialog,destroy),
    	message(Dialog,free)))),
    
    new(Figura,figure),
    new(Bitmap,bitmap(resource(img_principal),@on)),

    send(Bitmap,name,1),
    send(Figura,display,Bitmap),
    send(Figura,status,1),
    send(Dialog,append(Label)),
    send(Dialog,display,Label,point(80,20)),
    send(Dialog,display,Label2,point(40,50)),
    send(Dialog,display,Label3,point(20,130)),
    send(Dialog,display,Menu, point(10,20)),

    send(Dialog,display,Figura,point(20,80)),
    send(Dialog,display,Exit,point(20,200)),
    send(Dialog,display,Start,point(80,200)),
    send(Dialog,open_centered).

%
% Inicia la interfaz del cuestionario:
% en base a las respuestas se puede hacer 
% una consulta, en caso de que no haya resultados
% se podra aniadir nuevo conocimiento llamando 
% a la "interfazAdquisicon" que se encuentra en el
% "modulo_adquisicion.pl"
%
cuestionario :-
	new(Dialog, dialog('Sistema experto de excusas')),
	send_list(
		Dialog, append, 
		[new(Pregunta1, new(Pregunta1, menu('¿A quien le diras la excusa?'))), 
		new(Pregunta2, new(Pregunta2, menu('¿Por que quieres decir una excusa?'))), 
		new(Pregunta3, new(Pregunta3, menu('¿Cual es la gravedad de la situacion?'))), 
		new(Pregunta4, new(Pregunta4, menu('¿Que tan importante es la persona?'))), 
		new(Pregunta5, new(Pregunta5, menu('Elije un nivel para la excusa:'))), 
		button(cancelar, and(message(@prolog, main),
				message(Dialog, destroy),
				message(Dialog, free))), 
		button(consultar, and(message(@prolog, 
				imprimir_excusas, 
				Pregunta1?selection, 
				Pregunta2?selection, 
				Pregunta3?selection, 
				Pregunta4?selection, 
				Pregunta5?selection),
				message(Dialog, destroy),
				message(Dialog, free))),
		button('aniadir conocimiento', and(message(@prolog, interfazAdquisicion, 
				Pregunta1?selection, 
				Pregunta2?selection, 
				Pregunta3?selection, 
				Pregunta4?selection,
				Pregunta5?selection)))
		]),
	send_list(Pregunta1, append, ['maestro', 'amigo','familiar']),
	send_list(Pregunta2, append, ['flojera', 'falta de tiempo','problemas de salud']),
	send_list(Pregunta3, append, ['gravedad baja', 'gravedad media','gravedad alta']),
	send_list(Pregunta4, append, ['importancia baja','importancia alta']),
	send_list(Pregunta5, append, ['nivel bajo', 'nivel medio','nivel alto']),
	send(Dialog, default_button, consultar),
	send(Dialog, open_centered).	
%
% excusa(+R1, +R2, +R3, +R4, +R5)
%	Regla general que se encarga de 
%	procesar la seleccion del usuario
%	generada en la interfaz "encuesta."
%

excusa(_, _, _, _, _) :-
	obtenerExcusa(Excusa),	
	descripcion(Excusa, Descripcion),
	obtenerImagen(Excusa, Imagen),
	obtenerExplicacion(Excusa, Explicacion),
	% writeln(Excusa),
	(Excusa = noexiste -> resultado(Descripcion, Explicacion ,Imagen)).

excusa(R1, R2, R3, R4, R5) :- 
	obtenerExcusa(Excusa),	
	pregunta1(Excusa, R1),
	pregunta2(Excusa, R2),
	pregunta3(Excusa, R3),
	pregunta4(Excusa, R4),
	pregunta5(Excusa, R5),
	descripcion(Excusa, Descripcion),
	obtenerImagen(Excusa, Imagen),
	obtenerExplicacion(Excusa, Explicacion),
	resultado(Descripcion, Explicacion ,Imagen).
	
% 
% imprimir_excusas(+R1, +R2, +R3, +R4, +R5)
%	Esta regla recibe los parametros elegidos
%	directamente de la encuesta y se lo pasa
%	a 'excusa/5' para evaluar la respuesta,
%	una vez terminada la consulta esta regla
%	falla y mediante Backtracking regresa 
%	hasta la ultima consulta devuelta y 
%	continua la busqueda para encontrar 
%	mas coincidencias
%
imprimir_excusas(R1,R2,R3,R4,R5) :-
	excusa(R1,R2,R3,R4,R5),
	fail.
%
% imprimir_excusas(_,_,_,_,_)
%	metodo que asegura que cuando las llamadas 
%	recursivas terminen y encuentren todos los
%	resultados, el programa termine de forma segura 
%	retornando un 'true' como respuesta.
%

%
% resultado(+Descripcion, +Explicacion, +Img)
%	regla que sirve para mostrar
%	en la interfaz la excusa encontrada
%	y su respectiva imagen asociada
%
resultado(Descripcion, Explicacion, Img):-
	new(Dialog, dialog),
	new(Window,  window('Respuesta', size(250, 250))),
	new(Button, button(cerrar, and(
				message(Dialog, destroy),
				message(Dialog, free)))), 
	new(Label0,label(nombre,'Su excusa perfecta es:')),
	new(Label1,label(nombre,Descripcion)),
	new(Label2,label(nombre,'Explicacion:')),
	new(Label3,label(nombre,Explicacion)),
	new(Imagen,image(Img)),
    new(Bitmap,bitmap(Img)),
 	new(Figura,figure),

    send(Figura,display,Bitmap),
    send(Dialog,display,Figura,point(10,10)),
	send(Window,display,Button,point(10,230)),    
	send(Window,display,Label0,point(10,10)),
	send(Window,display,Label1,point(10,50)),
	send(Window,display,Label2,point(10,75)),
	send(Window,display,Label3,point(10,100)),
	
	send(Dialog, below, Window),
	send(Dialog, open_centered).
	
	

%
% Interfaz del modulo de adquisicion:
% 	Recibe los 5 parámetros elegidos por 
% 	el usuario que serán usados para 
%	poder agregar nuevo conocimiento al 
%	'motor_inferencia'.pl. 
%
interfazAdquisicion(R1,R2,R3,R4,R5) :- 
	new(Dialog, dialog('Modulo de adquisicion')),
	send_list(
		Dialog, append,
		[new(Pregunta1, new(Pregunta1, menu('¿A quien le diras la excusa?'))), 
		new(Pregunta2, new(Pregunta2, menu('¿Por que quieres decir una excusa?'))), 
		new(Pregunta3, new(Pregunta3, menu('¿Cual es la gravedad de la situacion?'))), 
		new(Pregunta4, new(Pregunta4, menu('¿Que tan importante es la persona?'))), 
		new(Pregunta5, new(Pregunta5, menu('Elije un nivel para la excusa'))),
		
		new(NombreExcusa, text_item('Nombre de la excusa')),
		new(@txt1,label(nombre,
			'Ingrese un nombre corto sin espacios en blanco para asignarle un \nidentificador a la nueva excusa.  e.g. "tengo_diarrea"')),

		new(Excusa, text_item('Excusa')),
		new(@txt2,label(nombre2,
			'Ingrese un texto descriptivo para la nueva excusa.  e.g. "no podre ir \na clases por que me dio diarreas"')),

		new(ExplicacionExcusa, text_item('Descripcion de la excusa:')),
		new(@txt3,label(nombre3,
			'Ingrese una descripcion para la excusa.  e.g. "usa esta excusa cuando tengas problemas con un profesor."')),

		new(NombreImg, text_item('nombre de imagen')),
		new(@txt4,label(nombre4,
			'Ingrese el nombre de la imagen asociada.  e.g. "diarrea.jpg"')),
			
		button(cancelar, and(message(@prolog, 
			cuestionario), 
			message(@txt1, destroy),
			message(@txt1, free),
			message(@txt2, destroy),
			message(@txt2, free),
			message(@txt3, destroy),
			message(@txt3, free),
			message(Dialog, destroy),
			message(Dialog, free))),
		button(guardar, and(message(@prolog, 
			nuevoConocimiento, 
			R1,
			R2,
			R3,
			R4,
			R5,
			NombreExcusa?selection,
			Excusa?selection,
			ExplicacionExcusa?selection,
			NombreImg?selection),
			message(@txt1, destroy),
			message(@txt2, destroy),
			message(@txt3, destroy),
			message(@txt1, free),
			message(@txt2, free),
			message(@txt3, free),
			message(Dialog, destroy),
			message(Dialog, free)))
		]),
	send_list(Pregunta1, append, R1),
	send_list(Pregunta2, append, R2),
	send_list(Pregunta3, append, R3),
	send_list(Pregunta4, append, R4),
	send_list(Pregunta5, append, R5),
	
	send(Dialog, default_button, guardar),
	send(Dialog, open_centered).

nuevoConocimiento(R1, R2, R3, R4, R5, NombreExcusa, Excusa, ExplicacionExcusa, NombreImg) :- 
	assertz(obtenerExcusa(NombreExcusa)),
	assertz(pregunta1(NombreExcusa, R1)),
	assertz(pregunta2(NombreExcusa, R2)),
	assertz(pregunta3(NombreExcusa, R3)),
	assertz(pregunta4(NombreExcusa, R4)),
	assertz(pregunta5(NombreExcusa, R5)),
	assertz(descripcion(NombreExcusa, Excusa)),
	assertz(obtenerImagen(NombreExcusa, NombreImg)),
	assertz(obtenerExplicacion(NombreExcusa, ExplicacionExcusa)),
	actualizar.
	
actualizar :- 
	tell('base_conocimiento.pl'),
	listing(obtenerExcusa),
	listing(pregunta1),
	listing(pregunta2),
	listing(pregunta3),
	listing(pregunta4),
	listing(pregunta5),
	listing(descripcion),
	listing(obtenerImagen),
	listing(obtenerExplicacion),
	told.

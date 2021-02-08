patches-own[pintadas]

globals [
pasto
agua
largo-del-cuerpo
velocidad
puntuacion
]

;Configura el mundo para empezar a jugar
to configurar
  ca
  set pasto[54 55 56]
  set agua[94 95 96]
  ask patches[
    set pcolor one-of pasto
    set pintadas 0
  ]

  crt 1[   ;Crea 1 tortuga que sera la cabeza de nuestra serpiente
    set color yellow
    set heading 0
  ]

  ;Demarca de color azul la zona limite del mundo hasta donde puede llegar la culebra
  ask patches[
    if(pxcor = 18 or pycor = 18  or pxcor = -18 or pycor = -18)
    [set pcolor one-of agua]
  ]
  set largo-del-cuerpo 3
  set velocidad 1
  set puntuacion 0

  crear-comida
end


;Crea la comida en punto aleatorio del mundo
to crear-comida
  ask one-of patches with[pcolor = 54 or pcolor = 55 or pcolor = 56]
  [
    set pcolor 32 ;32 es un color cafe oscuro
    sprout 1[
      set size 1
      set shape "plant"
      set color green
    ]
  ]
end

;Empieza el juego
to empezar
  wait 0.2 / velocidad
  ask turtles with[who = 0][
    fd 1
    morir
    comer
    set pcolor red ;Pinta de rojo la parcela por la que va la cabeza de la serpiente, así se crea la ilusión del "cuerpo de la serpiente"
    set pintadas largo-del-cuerpo + 1
  ]

  ask patches with[pintadas > 0 ][ ;Que una parcela tenga pintadas > 0 significa que es parte del cuerpo de la serpiente, es decir esta pintada de rojo
    despintar-cuerpo
  ]

  ;Si y solo si la serpiente murió, muestra que el juego terminó
  if(count patches with[pcolor = red] = 0)
  [
   user-message (word  "JUEGO TERMINADO\n Puntuación: " puntuacion " puntos")
   stop
  ]
end

;Si la serpiente se choca con su cuerpo o se sale de los limites se muere
to morir
  if(pcolor = red or member? pcolor agua)
   [die]
end

;Si la cabeza de la serpiente llega a la comida entonces come
to comer
   if(pcolor = 32) ; Esto quiere decir que la cabeza de la serpiente llego a la comida
   [
     ask turtles with[shape = "plant"][die]

     set largo-del-cuerpo largo-del-cuerpo + 1
     set velocidad velocidad + 0.06
     set puntuacion puntuacion + 1
     crear-comida
   ]
end

;Pinta de negro las parcelas que había pintado de rojo anteriormente para dar la ilusión de que la serpiente se mueve
to despintar-cuerpo
   set pintadas pintadas - 1

   if(pintadas = 0)
  [set pcolor one-of pasto]
end

;A CONTINUACIÓN LOS CONTROLES PA DIRECCIONAR LA TORTUGA
to arriba
  if(heading != 180)
  [set heading 0]
end

to abajo
  if(heading != 0)
  [ set heading 180 ]
end

to derecha
  if(heading != 270)
  [set heading 90]
end

to izquierda
  if(heading != 90)
  [ set heading 270]
end

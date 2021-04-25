[^1]: Revisa el contenido de las carpetas del proyecto, ¿qué carpetas se han creado y para qué sirve cada una?
- e2e: carpeta con los tests end-to-end.
- node_module: módulos y dependencias del proyecto.
- resources: iconos y splashscreen de las plataformas
- src: código fuente-
- app: código de la aplicación.
- assets: recursos de la aplicación.
- theme: temas y estilos.
- manifest.json: configuración de proyecto.
- index.html: fichero principal que inicia la app.
- main.ts: fichero que inicia la carga de la app.
- ionic.config.json: configuración del proyecto de Ionic.
- package.json: Dependencias y paquetes de Node.Js.

[^2]: Como podrás ver no se han creado las carpetas de Cordova, prueba a añadir la plataforma "android" y revisa las nuevas carpetas que se añaden.
- ejecutar `ionic cordova platform add android`
[^3]: Revisa el contenido de la carpeta "src" y busca el contenido de la página que se incluye por defecto (llamada home).

[^4]: ¿Cómo se carga la página por defecto? Busca si se hace referencia a la página "home" desde algún fichero y cómo se indica que se cargue como página principal.
Esta el el fichero global de rutas `app-routing.module.ts` es la ruta raiz de la aplicación y portanto la página principal.

[^5]: ¿Para qué sirven las opciónes `-l` y `-c`?
- -l sirve para iniciar la aplicación con auto cargado, es decir, que al realizar cambios se actualice automáticamente la emulación.
- -c sirve para activar los consolelog

## PD: Vaya peliculones tenemos en el videoclub... xD

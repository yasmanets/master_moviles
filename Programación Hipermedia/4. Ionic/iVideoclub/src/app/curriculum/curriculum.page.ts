import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({
  selector: 'app-curriculum',
  templateUrl: './curriculum.page.html',
  styleUrls: ['./curriculum.page.scss'],
})
export class CurriculumPage implements OnInit, OnDestroy {

  listaTrabajos: {fecha: string, desc: string}[];

  constructor() {
    this.listaTrabajos = [
      { fecha: '2020-actualidad', desc: 'Estudiante del Máster Universitario en Desarrollo de Software para Dispositivos Móviles' },
      { fecha: '2020-actualidad', desc: 'Estudiante del Máster Universitario en Ciberseguridad' },
      { fecha: '2017-2020', desc: 'Estudiante de Ingeniería Informática de Servicios y Aplicacioines en el campus de Segovia de la UVa' },
    ];
  }

  ngOnInit() {
    console.log('[curriculum] página cargada');
  }

  ionViewWillEnter() {
    console.log('[curriculum] la página se va a mostrar');
  }

  ionViewDidEnter() {
    console.log('[curriculum] la página es visible');
  }

  ionViewWillLeave() {
    console.log('[curriculum] la página va a salir');
  }

  ionViewDidLeave() {
    console.log('[curriculum] la página ya no es visible');
  }

  ngOnDestroy() {
    console.log('[curriculum] ngOnDestroy');
  }

}

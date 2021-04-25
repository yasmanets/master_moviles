import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({
  selector: 'app-autor',
  templateUrl: './autor.page.html',
  styleUrls: ['./autor.page.scss'],
})

export class AutorPage implements OnInit, OnDestroy {

  autor: {
    name: string,
    email: string,
    twitter: string,
    phone: string,
  };

  constructor( ) {
    this.autor = {name: 'Yaser El Dabete', email: 'yeda1@alu.ua.es', twitter: '@yasmaniaco', phone: '111222333'};
  }

  ngOnInit() {
    console.log('[autor] página cargada');
  }

  ionViewWillEnter() {
    console.log('[autor] la página se va a mostrar');
  }

  ionViewDidEnter() {
    console.log('[autor] la página es visible');
  }

  ionViewWillLeave() {
    console.log('[autor] la página va a salir');
  }

  ionViewDidLeave() {
    console.log('[autor] la página ya no es visible');
  }

  ngOnDestroy() {
    console.log('[autor] ngOnDestroy');
  }

}

import { Component, OnInit, OnDestroy } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage implements OnInit, OnDestroy {

  constructor() {}

  ngOnInit() {
    console.log('[inicio] página cargada');
  }

  ionViewWillEnter() {
    console.log('[inicio] la página se va a mostrar');
  }

  ionViewDidEnter() {
    console.log('[inicio] la página es visible');
  }

  ionViewWillLeave() {
    console.log('[inicio] la página va a salir');
  }

  ionViewDidLeave() {
    console.log('[inicio] la página ya no es visible');
  }

  ngOnDestroy() {
    console.log('[inicio] ngOnDestroy');
  }
}

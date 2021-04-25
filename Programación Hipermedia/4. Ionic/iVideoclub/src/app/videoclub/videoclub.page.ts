import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { PeliculasAPIService } from '../service/peliculasAPI/peliculas-api.service';

@Component({
  selector: 'app-videoclub',
  templateUrl: './videoclub.page.html',
  styleUrls: ['./videoclub.page.scss'],
})
export class VideoclubPage implements OnInit, OnDestroy {

  listarPeliculas: any[];
  modoLista: boolean;

  constructor(
    private router: Router,
    // Prueba de los ejecrcicios anteriores
    // private peliculasService: PeliculasService
    private peliculasApiService: PeliculasAPIService,
  ) {
    this.peliculasApiService.getPeliculas().subscribe(
      result => {
        this.listarPeliculas = result;
      },
      error => {
        console.log(error);
      }
    );
    this.modoLista = true;
  }

  ngOnInit() {
    console.log('[videoclub] página cargada');
  }

  ionViewWillEnter() {
    console.log('[videoclub] la página se va a mostrar');
  }

  ionViewDidEnter() {
    console.log('[videoclub] la página es visible');
  }

  ionViewWillLeave() {
    console.log('[videoclub] la página va a salir');
  }

  ionViewDidLeave() {
    console.log('[videoclub] la página ya no es visible');
  }

  ngOnDestroy() {
    console.log('[videoclub] ngOnDestroy');
  }

  verPaginaDetalle(id: number): void {
    this.router.navigate(['/detalle', id]);
  }

  cambiarVista(): void {
    this.modoLista = !this.modoLista;
  }

}

import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { PeliculasAPIService } from '../service/peliculasAPI/peliculas-api.service';

@Component({
  selector: 'app-detalle',
  templateUrl: './detalle.page.html',
  styleUrls: ['./detalle.page.scss'],
})
export class DetallePage implements OnInit {

  pelicula: any;

  constructor(
    private activatedRoute: ActivatedRoute,
    private peliculasApiService: PeliculasAPIService,
  ) { }

  ngOnInit() {
    const id = this.activatedRoute.snapshot.paramMap.get('id');
    // Prueba de los pasos anteriores
    console.log(id);
    this.pelicula = this.peliculasApiService.getPelicula(id).subscribe(
      result => {
        this.pelicula = result;
      },
      error => {
        console.log(error);
      }
    );
  }

}

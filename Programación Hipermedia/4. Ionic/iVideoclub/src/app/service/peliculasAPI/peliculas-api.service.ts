import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PeliculasAPIService {

  APIep = 'http://gbrain.dlsi.ua.es/videoclub/api/v1/catalog';

  constructor(
    private http: HttpClient
  ) { }

  getPeliculas(): Observable<any> {
    return this.http.get(this.APIep);
  }

  getPelicula(id: string): Observable<any> {
    return this.http.get(`${this.APIep}/${id}`);
  }
}

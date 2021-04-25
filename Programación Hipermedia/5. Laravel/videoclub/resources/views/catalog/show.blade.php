@extends('partials.master')

@section('content')
<div class="row">
    <div class="col-sm-4 d-flex justify-content-center">
        <img src="{{$pelicula->poster}}" style="height:auto"/>
    </div>
    <div class="col-sm-8">
    <h2 style="min-height:45px;margin:5px 0 10px 0">
        {{$pelicula->title}}
    </h2>
    <h5>Director: {{$pelicula->director}}</h5>
    <h5>Año: {{$pelicula->year}}</h5>
    <p style="text-align: justify"><strong>Resumen</strong>: {{$pelicula->synopsis}}</p>

    @if ( $pelicula->rented)
        <p><strong>Estado</strong>: Película actualmente alquilada</p>
        <form action="{{ url('catalog/return/' . $pelicula->id) }}" method="POST" style="display:inline">
            @method('PUT')
            @csrf
            <button type="submit" class="btn btn-danger" style="display:inline">Devolver película</button>
        </form>
    @else
        <p><strong><strong>Estado</strong>: Película disponible</p>
        <form action="{{ url('catalog/rent/' . $pelicula->id) }}" method="POST" style="display:inline">
            @method('PUT')
            @csrf
            <button type="submit" class="btn btn-info" style="display: inline;">Alquilar película</button>
        </form>
    @endif
    <a href="{{ url('/catalog/edit/' . $pelicula->id ) }}" class="btn btn-warning">
        <span class="fas fa-pen"></span>
        Editar película
    </a>

    <form action="{{ url('catalog/delete/' . $pelicula->id) }}" method="POST" style="display:inline">
        @method('DELETE')
        @csrf
        <button type="submit" class="btn btn-danger" style="display: inline;">Eliminar película</button>
    </form>

    <a href="/videoclub/public/catalog" class="btn btn-outline-dark">
        <span class="fas fa-chevron-left"></span>
        Volver al listado
    </a>
    </div>
</div>
@endsection

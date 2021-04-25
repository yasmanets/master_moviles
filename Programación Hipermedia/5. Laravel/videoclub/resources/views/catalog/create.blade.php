@extends('partials.master')

@section('content')
<div class="row" style="margin-top:40px">
   <div class="offset-md-3 col-md-6">
      <div class="card">
         <div class="card-header text-center">
            Añadir película
         </div>
         <div class="card-body" style="padding:30px">

            {{-- TODO: Abrir el formulario e indicar el método POST --}}
            <form action="{{ url('catalog/create') }}" method="POST">

                {{-- TODO: Protección contra CSRF --}}
                @csrf

                <div class="form-group">
                    <label for="title" class="form-label">Título</label>
                    <input type="text" name="title" id="title" class="form-control">
                </div>

                <div class="form-group">
                    <label for="year" class="form-label">Año</label>
                    <input type="number" name="year" id="year" class="form-control">
                </div>

                <div class="form-group">
                    <label for="director" class="form-label">Director</label>
                    <input type="text" name="director" id="director" class="form-control">
                </div>

                <div class="form-group">
                    <label for="poster" class="form-label">Poster</label>
                    <input type="text" name="poster" id="poster" class="form-control">
                </div>

                <div class="form-group">
                    <label for="synopsis" class="form-label">Resumen</label>
                    <textarea name="synopsis" id="synopsis" class="form-control" rows="3"></textarea>
                </div>

                <div class="form-group text-center">
                    <button type="submit" class="btn btn-primary" style="padding:8px 100px;margin-top:25px;">
                        Añadir película
                    </button>
                </div>

            {{-- TODO: Cerrar formulario --}}
            </form>
         </div>
      </div>
   </div>
</div>
@endsection

<?php

namespace App\Http\Controllers;

use App\Models\Movie;
use Bpocallaghan\Alert\Facades\Alert;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CatalogController extends Controller
{
    public function getIndex()
    {
        $movies = DB::table('movies')->get();
        return view('catalog.index', array('arrayPeliculas'=>$movies));
    }

    public function getShow($id)
    {
        $movie = Movie::findOrFail($id);
        return view('catalog.show', array('pelicula'=>$movie));
    }

    public function getCreate()
    {
        return view('catalog.create');
    }

    public function getEdit($id)
    {
        $movie = Movie::findOrFail($id);
        return view('catalog.edit', array('pelicula'=>$movie));
    }

    public function postCreate(Request $request) {
        $movie = new Movie;
        $movie->title = $request->input('title');
        $movie->year = $request->input('year');
        $movie->director = $request->input('director');
        $movie->poster = $request->input('poster');
        $movie->rented = false;
        $movie->synopsis = $request->input('synopsis');
        $movie->save();
        Alert::info('La película se ha guardado correctamente.');
        return redirect('/catalog');
    }

    public function putEdit(Request $request, $id) {
        $movie = Movie::findOrFail($id);
        $movie->title = $request->input('title');
        $movie->year = $request->input('year');
        $movie->director = $request->input('director');
        $movie->poster = $request->input('poster');
        $movie->synopsis = $request->input('synopsis');
        $movie->save();
        Alert::info('La película se ha editado correctamente.');
        return redirect('/catalog/show/' . $id);
    }

    public function putRent($id) {
        $movie = Movie::findOrFail($id);
        $movie->rented = true;
        $movie->save();
        Alert::info('La película se ha alquilado correctamente.');
        return redirect('/catalog/show/' . $id);
    }

    public function putReturn($id) {
        $movie = Movie::findOrFail($id);
        $movie->rented = false;
        $movie->save();
        Alert::info('La película se ha devuelto correctamente.');
        return redirect('/catalog/show/' . $id);
    }

    public function deleteMovie($id) {
        $movie = Movie::findOrFail($id);
        $movie->delete();
        Alert::info('La película se ha eliminado correctamente.');
        return redirect('/catalog');
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Movie;
use Illuminate\Http\Request;

class APICatalogController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return response()->json( ['msg' => 'entra en index', Movie::all() ]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $movie = new Movie;
        $movie->title = $request->input('title');
        $movie->year = $request->input('year');
        $movie->director = $request->input('director');
        $movie->poster = $request->input('poster');
        $movie->rented = false;
        $movie->synopsis = $request->input('synopsis');
        $movie->save();
        return response()->json( ['error' => false,
        'msg' => 'La película se ha creado correctamente' ] );
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return response()->json( Movie::findOrFail($id) );
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $movie = Movie::findOrFail($id);
        if ($request->has('title')) {
            $movie->title = $request->input('title');
        }
        if ($request->has('year')) {
            $movie->year = $request->input('year');
        }
        if ($request->has('director')) {
            $movie->director = $request->input('director');
        }
        if ($request->has('poster')) {
            $movie->poster = $request->input('poster');
        }
        if ($request->has('synopsis')) {
            $movie->synopsis = $request->input('synopsis');
        }
        $movie->save();
        return response()->json( ['error' => false,
        'msg' => 'La película se ha editado correctamente' ] );
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $movie = Movie::findOrFail($id);
        $movie->delete();
        return response()->json( ['error' => false,
        'msg' => 'La película se ha eliminado correctamente' ] );
    }

    public function putRent($id) {
        $m = Movie::findOrFail( $id );
        $m->rented = true;
        $m->save();
        return response()->json( ['error' => false,
                              'msg' => 'La película se ha marcado como alquilada' ] );
    }

    public function putReturn($id) {
        $m = Movie::findOrFail( $id );
        $m->rented = false;
        $m->save();
        return response()->json( ['error' => false,
                              'msg' => 'La película se ha marcado como devuelta' ] );
    }
}

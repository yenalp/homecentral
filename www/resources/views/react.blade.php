@extends('layouts.react-app')

@section('content')
    <div class="container">

        <div class="timer"></div>
        <div class="slideshow">

            <div class="slide">
                <div class="row">
                    <div class="col">
                        <div id="water-level-cylinder"></div>
                    </div>
                </div>
            </div>

            <div class="slide">
                <div class="row">
                    <div class="col">
                        <div id="outside-temp"></div>
                    </div>
                </div>
            </div>

        </div>
    </div>
@endsection

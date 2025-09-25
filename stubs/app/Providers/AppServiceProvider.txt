<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        \Illuminate\Support\Facades\URL::forceScheme('https');

        \Illuminate\Validation\Rules\Password::min(8)
            ->mixedCase()
            ->numbers()
            ->symbols()
            ->uncompromised();
    }
}

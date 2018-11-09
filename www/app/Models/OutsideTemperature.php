<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class OutsideTemperature extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'outdoor_temperatures';
    
    /**
     * The list of attribute's that can be mass-assigned
     *
     * @var array
     */
    protected $fillable = [
        'temperature',
        'updated_at',
        'created_at',
        'id',
    ];
    /**
     * The attributes that should be casted to native types.
     *
     * @var array
     */
    protected $casts = [
        'temperature' => 'string',
        'id' => 'integer',
    ];
    /**
     * The attributes that should be hidden.
     *
     * @var array
     */
    protected $hidden = [
        'created_at',
    ];
    public $fieldsToLog = [
        'temperature',
    ];

    /**
     * @SuppressWarnings(PHPMD.BooleanArgumentFlag)
     */
    public function save(array $options = [], $isLoggingOnSave = true)
    {
        parent::save($options, $isLoggingOnSave);
    }
}

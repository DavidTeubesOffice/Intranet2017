<?php
/**
  * @var \App\View\AppView $this
  */
use Cake\Utility\Hash;

$this->Html->templates([
    'icon' => '<i class="fa fa-{{type}}{{attrs.class}}"{{attrs}}></i>'
]);
?>
<div class="panel panel-default">
    <div class="panel-heading">
        <div class="row">
            <div class="col col-md-3"><div class="panel-title">Users</div></div>
            <div class="col col-md-9">
                <div class="btn-group pull-right">
                    <?= $this->Html->link($this->Html->icon('plus'). ' Add', '/users/add', ['class' => 'btn btn-default btn-xs', 'escape' => false]) ?>
                </div>
            </div>
        </div>
<!--        <div class="panel-title">Test</div>-->
    </div>
    <div class="panel-body">
        <table class="table table-bordered table-responsive table-hover table-condensed">
            <?= $this->Html->tableHeaders(Hash::extract($Users, 'users.{n}.attributes.{n}.attribute_title')) ?>
            <?= $this->Html->tableCells(Hash::combine($Users, 'users.{n}.attributes.{n}.attribute_title', 'users.{n}.attributes.{n}.attribute_value')) ?>
        </table>
    </div>
</div>


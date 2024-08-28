<script lang="ts">
</script>

<div class="container">
    <div class="title-card">
        <div class="title-word">OCTO</div>
        <div>GUNS</div>
    </div>
    <button on:click={() => window.location.href = '/start'}>Press to Play</button>
</div>

<style>
    .container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        text-align: center;
    }

    .title-card {
        font-family: 'Block';
        font-size: 15em;
        line-height: 0.8;
        margin-bottom: -0.1em;
        padding-top: 5%;
    }

    .title-word {
        padding: 15px;
    }

    button {
        font-size: 1em;
        padding: 10px;
        margin-top: 8%;
    }
</style>

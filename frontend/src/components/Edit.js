import classes from './Edit.module.css';
import {useRef} from 'react';
import {useState} from 'react';

function Edit(props)
{
    const titleRef2 = useRef();
    const addressRef2 = useRef();
    const maxRef2 = useRef();
    const clientNameRef2 = useRef();
    const clientEmailRef2 = useRef();
    const clientPhoneRef2 = useRef();
    const startRef2 = useRef();
    const endRef2 = useRef();
    const briefRef2 = useRef();

    const [errorMsg, setMsg] = useState("");

    async function editHandler(event)
    {
        event.preventDefault();
        var id = props.jid;
        var title = titleRef2.current.value;
        var address = addressRef2.current.value;
        var max = maxRef2.current.value;
        var clientname = clientNameRef2.current.value;
        var clientemail = clientEmailRef2.current.value;
        var clientphone = clientPhoneRef2.current.value;
        var start = startRef2.current.value;
        var end = endRef2.current.value;
        var briefing = briefRef2.current.value;
        if (max < props.current)
        {
            setMsg("Cannot lower max # of workers");
        }
        else{

            const Data =
            {
                "id": id,
                'title': title,
                "email": clientemail,
                "address": address,
                "clientname": clientname,
                "clientcontact": clientphone,
                "start": start,
                "end": end,
                "briefing": briefing,
                "max": max
            };

            var js = JSON.stringify(Data);
            try{
                const response = await fetch('https://cop4331group2.herokuapp.com/api/editorder', 
                {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
                var res = JSON.parse(await response.text());

            }catch(e){
                alert(e.toString());
            }

            if(res.error == 'Edits applied!')
            {
                var fn = props.onClick;
                fn();
            }
        }
    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheading}>
                <h3 className={classes.h3}>Edit Job</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <form onSubmit={editHandler}>
                    <div>
                        <span className={classes.span}>Title</span>
                        <span className={classes.span2}>Address</span>
                        <span className={classes.span3}># Workers</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search} required id='title2' ref={titleRef2} defaultValue={props.title}></input>
                        <input type='text' className={classes.search} required id='address2' ref={addressRef2} defaultValue={props.address}></input>
                        <input type='text' className={classes.work} required id='maxWorkers2' ref={maxRef2} defaultValue={props.maxWorkers}></input>
                    </div>
                    <div>
                        <span className={classes.span}>Client Name</span>
                        <span className={classes.span4}>Client Email</span>
                        <span className={classes.span5}>Client Phone</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search2} required id='cName2' ref={clientNameRef2} defaultValue={props.client}></input>
                        <input type='email' className={classes.search2} required id='cEmail2' ref={clientEmailRef2} defaultValue={props.email}></input>
                        <input type='text' className={classes.search2} required id='cPhone2' pattern='[0-9]{3}-[0-9]{3}-[0-9]{4}' placeholder='Format: 123-456-7890' ref={clientPhoneRef2} defaultValue={props.phone}></input>
                    </div>
                    <div>
                        <span className={classes.span6}>Start Date</span>
                        <span className={classes.span7}>End Date</span> <br></br>
                    </div>
                    <div className={classes.center}>
                        <input type='date' className={classes.date} required id='start2' ref={startRef2} defaultValue={props.start}></input>
                        <input type='date' className={classes.date} required id='end2' ref={endRef2} defaultValue={props.end}></input> <br></br>
                        <textarea rows='5' cols='75' className={classes.ta} required ref={briefRef2} defaultValue={props.briefing}></textarea> <br></br>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                        <button className={classes.button}>Apply Edits</button>
                    </div>
                </form>
            </div>
        </div>
    );
}

export default Edit;
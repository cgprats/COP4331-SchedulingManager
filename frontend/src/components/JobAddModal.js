import classes from './JobAddModal.module.css';
import {useRef} from 'react';

function JobAddModal(props)
{
    const titleRef = useRef();
    const addressRef = useRef();
    const maxRef = useRef();
    const clientNameRef = useRef();
    const clientEmailRef = useRef();
    const clientPhoneRef = useRef();
    const startRef = useRef();
    const endRef = useRef();
    const briefRef = useRef();

    async function addHandler(event)
    {
        event.preventDefault();
        var user = JSON.parse(localStorage.getItem('user_data'));

        const title = titleRef.current.value;
        const address = addressRef.current.value;
        const max = maxRef.current.value;
        const clientname = clientNameRef.current.value;
        const clientemail = clientEmailRef.current.value;
        const clientphone = clientPhoneRef.current.value;
        const start = startRef.current.value;
        const end = endRef.current.value;
        const briefing = briefRef.current.value;

        const companyCode = user.companyCode;

        const Data =
        {
            title: title,
            email: clientemail,
            address: address,
            clientname: clientname,
            clientcontact: clientphone,
            start: start,
            end: end,
            max: max,
            companyCode: companyCode,
            briefing: briefing
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/addorder', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());

        }catch(e){
            alert(e.toString());
        }

        if (res.error == 'Job added!')
        {
            var fr = props.onClick;
            fr();
        }
    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheading}>
                <h3 className={classes.h3}>Add New Job</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <form onSubmit={addHandler}>
                    <div>
                        <span className={classes.span}>Title</span>
                        <span className={classes.span2}>Address</span>
                        <span className={classes.span3}># Workers</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search} required id='title' ref={titleRef}/>
                        <input type='text' className={classes.search} required id='address' ref={addressRef}/> 
                        <input type='text' className={classes.work} required id='maxWorkers' ref={maxRef}/>
                    </div>
                    <div>
                        <span className={classes.span}>Client Name</span>
                        <span className={classes.span4}>Client Email</span>
                        <span className={classes.span5}>Client Phone</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search2} required id='cName' ref={clientNameRef}/>
                        <input type='email' className={classes.search2} required id='cEmail' ref={clientEmailRef}/>
                        <input type='text' className={classes.search2} required id='cPhone' pattern='[0-9]{3}-[0-9]{3}-[0-9]{4}' placeholder='Format: 123-456-7890' ref={clientPhoneRef}/>
                    </div>
                    <div>
                        <span className={classes.span6}>Start Date</span>
                        <span className={classes.span7}>End Date</span> <br></br>
                    </div>
                    <div className={classes.center}>
                        <input type='date' className={classes.date} required id='start' ref={startRef}/>
                        <input type='date' className={classes.date} required id='end' ref={endRef}/> <br></br>
                        <textarea rows='5' cols='75' className={classes.ta} required placeholder='Job briefing' ref={briefRef}></textarea> <br></br>
                        <button className={classes.button}>Add Job</button>
                    </div>
                </form>
            </div>
        </div>
    );
}

export default JobAddModal;
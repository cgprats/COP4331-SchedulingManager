import NavBar from '../components/NavBar';
import WorkerNotes from '../components/WorkerNotes';
import WorkerTimes from '../components/WorkerTimes';
import {useRef} from 'react';
import {useState} from 'react';
import classes from './Workers.module.css';
import Backdrop from '../components/Backdrop';

function Workers()
{
    const [backdropIsVisible, setBackdropVisiblity] = useState(false);
    const [notesAreVisible, setNoteVisibility] = useState(false);
    const [timesheetIsVisible, setTimesheetVisibility] = useState(false);

    const searchTextRef = useRef();

    var activeName = 'Worker';

    var activeNotes = [
        {
            desc: 'this is an example note description.',
            title: 'example title',
            date: '2021-07-23'
        },

        {
            desc: 'this is another example of a note description.',
            title: 'example title #2',
            date: '2021-08-25'
        }
    ];

    var activeTimes = [
        {
            date: '2021-07-23',
            title: 'Example title',
            start: '8:30',
            end: '12:30'
        },
        {
            date: '2021-07-24',
            title: 'Example title 2',
            start: '9:30',
            end: '1:30'
        }
    ];

    var workers = [
        {
            FirstName: 'Sean',
            LastName: 'Bennett',
            Phone: '305-804-0523',
            Email: 'seanmbmiami@gmail.com'
        },

        {
            FirstName: 'Trish',
            LastName: 'Nigrelli',
            Phone: '305-519-8560',
            Email: 'kmbmiami@gmail.com'
        }
    ];


    function closeAll()
    {
        setBackdropVisiblity(false);
        setNoteVisibility(false);
        setTimesheetVisibility(false);
    }

    function loadNotes(email, name)
    {
        activeName = name;
        setBackdropVisiblity(true);
        setNoteVisibility(true);
    }

    function loadTimes(email, name)
    {
        activeName = name;
        setBackdropVisiblity(true);
        setTimesheetVisibility(true);
    }

    function searchHandler(event)
    {
        event.preventDefault();
    }

    return (
        <div className={classes.back}>
            <NavBar></NavBar>
            <div className={classes.card}>
                <div className={classes.cardheading}>
                    <h2 className={classes.h2}>Workers</h2>
                </div>
                <div>
                    <form onSubmit={searchHandler}>
                        <div className={classes.center}>
                            <input type='text' className={classes.search} placeholder='Name, email, phone, etc.' id='searchText' ref={searchTextRef}/>
                            <button className={classes.button}>Search</button>
                        </div>
                    </form>
                </div>
                <div>
                    <table className={classes.table}>
                        <tr>
                            <th className={classes.first}>Name</th>
                            <th className={classes.second}>Email</th>
                            <th className={classes.third}>Phone</th>
                            <th className={classes.fourth}></th>
                        </tr>
                        {workers.map(worker => 
                            <tr>
                                <td className={classes.first2}>{worker.FirstName} {worker.LastName}</td>
                                <td className={classes.second2}>{worker.Email}</td>
                                <td className={classes.third2}>{worker.Phone}</td>
                                <td className={classes.fourth2}>
                                    <button className={classes.button} onClick={()=> loadNotes(worker.Email, worker.FirstName)}>Notes</button>
                                    <button className={classes.button} onClick={()=> loadTimes(worker.Email, worker.FirstName)}>Timesheet</button>
                                </td>
                            </tr>
                        )}
                    </table>
                </div>
                <div>
                    {backdropIsVisible && <Backdrop onClick={closeAll}></Backdrop>}
                    {notesAreVisible && <WorkerNotes input={activeNotes} name = {activeName} onClick={closeAll}></WorkerNotes>}
                    {timesheetIsVisible && <WorkerTimes input={activeTimes} name = {activeName} onClick={closeAll}></WorkerTimes>}
                </div>
            </div>
        </div>
    );
}

export default Workers;
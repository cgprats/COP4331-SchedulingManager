import classes from './Timesheet.module.css';

function Timesheet(props)
{

    function reformatDate(input)
    {
        const year = input.substring(0, 4);
        const month = input.substring(5, 7);
        const day = input.substring(8, 10);
        return (month + '/' + day + '/' + year);
    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheader}>
                <h3 className={classes.h3}>Timesheet</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div className={classes.cardbody}>
                <table className={classes.table}>
                    <tr>
                        <th className={classes.first}>Date</th>
                        <th className={classes.second}>Hours</th>
                        <th className={classes.third}>Team Member</th>
                    </tr>
                    {props.input.map(info => 
                        <tr>
                            <td className={classes.first2}>{reformatDate(info.date)}</td>
                            <td className={classes.second2}>{info.start} - {info.end}</td>
                            <td className={classes.third2}>{info.firstName} {info.lastName}</td>
                        </tr>
                    )}
                </table>
            </div>
        </div>
    );
}

export default Timesheet;